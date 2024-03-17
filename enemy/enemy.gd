extends KinematicBody

export var move_to :Vector3
export var speed :float = 4

var velocity :Vector3

func _process(delta):
	var pos = global_transform.origin
	var dir = pos.direction_to(move_to)
	var dis = pos.distance_to(move_to)
	if dis < 0.6:
		set_process(false)
		queue_free()
		return
		
	velocity = dir * speed
	velocity = move_and_slide(velocity)
