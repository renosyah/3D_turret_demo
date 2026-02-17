extends Area

export var move_to :Vector3
export var max_dist :float = 50
export var speed :float = 15

var dir :Vector3
var dist :float

func _ready():
	set_as_toplevel(true)
	set_process(false)
	
func launch():
	var pos = global_transform.origin
	dir = pos.direction_to(move_to)
	set_process(true)
	
func _process(delta):
	if dist > max_dist:
		set_process(false)
		queue_free()
		return
		
	var vel = speed * delta
	translation += dir * vel
	dist += vel
	
func _on_bullet_body_entered(body):
	if is_instance_valid(body):
		body.kill()
