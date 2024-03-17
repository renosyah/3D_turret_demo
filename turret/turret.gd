extends Spatial

export var bullet_scene :PackedScene

export var is_limit_arc :bool = false
export var limit_rotation :float = 45
export var limit_elevation :float = 15

export var turret_rotation_speed :float = 8

var targets :Array

onready var body = $body
onready var gun = $body/gun
onready var timer = $Timer
onready var sprite_3d = $Sprite3D
onready var position_3d = $body/gun/Position3D

var spatial :Spatial = Spatial.new()

func _ready():
	add_child(spatial)
	spatial.translation = body.translation
	sprite_3d.set_as_toplevel(true)
	
func _process(delta):
	if targets.empty():
		return
		
	var target = targets[0]
	if not is_instance_valid(target):
		return
		
	var bullet_speed :float = 15
	var pos = gun.global_transform.origin
	var target_pos = target.global_transform.origin
	var dist_to_target_pos = pos.distance_to(target_pos)
	
	# get position where the target is gonna be
	var bullet_fly_time :float = dist_to_target_pos / bullet_speed
	var target_move_pos = target_pos + target.velocity * bullet_fly_time
	var dist_to_target_move_pos = pos.distance_to(target_move_pos)
	
	var turret_aiming_pos = pos + -gun.global_transform.basis.z * dist_to_target_move_pos
	turret_aiming_pos.y = target_move_pos.y
	
	spatial.look_at(target_move_pos, Vector3.UP)
	
	if is_limit_arc:
		spatial.rotation_degrees.y = clamp(spatial.rotation_degrees.y, -limit_rotation, limit_rotation)
		spatial.rotation_degrees.x = clamp(spatial.rotation_degrees.x, -limit_elevation, limit_elevation)
		
	else:
		spatial.rotation_degrees.y = wrapf(spatial.rotation_degrees.y, 0.0, 360.0)
		spatial.rotation_degrees.x = clamp(spatial.rotation_degrees.x, -45, 90)
	
	body.rotation.y = lerp_angle(body.rotation.y, spatial.rotation.y, turret_rotation_speed * delta)
	gun.rotation.x = lerp_angle(gun.rotation.x, spatial.rotation.x, turret_rotation_speed * delta)
	
	sprite_3d.translation = turret_aiming_pos
	
	# check turret aiming at is align 
	# with target position
	if not turret_aiming_pos.distance_to(target_move_pos) < 1:
		return
		
	if not timer.is_stopped():
		return
		
	timer.start()
	
	_shot_bullet()
	
func _shot_bullet():
	var b = bullet_scene.instance()
	b.move_to = gun.global_transform.origin + -gun.global_transform.basis.z * 10
	b.max_dist = 25
	add_child(b)
	b.translation = position_3d.global_transform.origin
	b.launch()
	
	
	
func _on_Area_body_entered(body):
	if not targets.has(body):
		targets.append(body)

func _on_Area_body_exited(body):
	if targets.has(body):
		targets.erase(body)


