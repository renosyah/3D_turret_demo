extends Area

export var move_to :Vector3
export var max_dist :float = 50

var dir :Vector3
var dist :float

func _ready():
	set_as_toplevel(true)
	set_process(false)
	
func launch():
	var pos = global_transform.origin
	dir = pos.direction_to(move_to + _get_added_spread(0.7))
	set_process(true)
	
func _get_added_spread(spread :float) -> Vector3:
	var v = Vector3.ONE
	v.x *= rand_range(-spread, spread)
	v.y *= rand_range(-spread, spread)
	v.z *= rand_range(-spread, spread)
	return v
	
func _process(delta):
	if dist > max_dist:
		set_process(false)
		queue_free()
		return
		
	var vel = 15 * delta
	translation += dir * vel
	dist += vel
	
func _on_bullet_body_entered(body):
	if is_instance_valid(body):
		body.queue_free()
