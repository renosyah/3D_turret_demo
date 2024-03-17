extends Spatial

export var bullet_scene :PackedScene

var targets :Array

onready var body = $body
onready var gun = $body/gun
onready var timer = $Timer
onready var sprite_3d = $Sprite3D
onready var position_3d = $body/gun/Position3D

var spatial :Spatial = Spatial.new()

func _ready():
	add_child(spatial)
	sprite_3d.set_as_toplevel(true)
	
func _process(delta):
	if targets.empty():
		return
		
	var target = targets[0]
	if not is_instance_valid(target):
		return
		
	var pos = gun.global_transform.origin
	var target_pos = target.global_transform.origin
	
	# get position where the target is gonna be
	var target_move_pos = target_pos + target.velocity
	var dist_to_target_move_pos = pos.distance_to(target_move_pos)

	var turret_aiming_pos = pos + -gun.global_transform.basis.z * dist_to_target_move_pos
	turret_aiming_pos.y = target_move_pos.y
	
	spatial.look_at(target_move_pos, Vector3.UP)
	spatial.rotation_degrees.y = wrapf(spatial.rotation_degrees.y, 0.0, 360.0)
	spatial.rotation_degrees.x = clamp(spatial.rotation_degrees.x, -45, 90)
	
	body.rotation.y = lerp_angle(body.rotation.y , spatial.rotation.y , 8 * delta)
	gun.rotation.x = lerp_angle(gun.rotation.x , spatial.rotation.x , 8 * delta)
	
	sprite_3d.translation = turret_aiming_pos
	
	# check turret aiming at is align 
	# with target position
	if not turret_aiming_pos.distance_to(target_move_pos) < 1:
		return
		
	if not timer.is_stopped():
		return
		
	timer.start()
	
	_shot_bullet(dist_to_target_move_pos)
	
func _shot_bullet(max_dist :float):
	var b = bullet_scene.instance()
	b.move_to = gun.global_transform.origin + -gun.global_transform.basis.z * 10
	b.max_dist = max_dist + 10
	add_child(b)
	b.translation = position_3d.global_transform.origin
	b.launch()
	
func _on_Area_body_entered(body):
	if not targets.has(body):
		targets.append(body)

func _on_Area_body_exited(body):
	if targets.has(body):
		targets.erase(body)


