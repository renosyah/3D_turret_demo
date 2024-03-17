extends Node

export var enemy_scene :PackedScene

onready var spawn = $Path/spawn
onready var to = $Path2/to
onready var timer = $Timer

func _ready():
	timer.start()
	
func _on_Timer_timeout():
	timer.start()
	
	spawn.unit_offset = randf()
	to.unit_offset = randf()
	
	var from_pos = spawn.global_transform.origin + (Vector3.UP * rand_range(-2, 2))
	var move_to = to.global_transform.origin
	
	var enemy = enemy_scene.instance()
	enemy.move_to = move_to
	add_child(enemy)
	enemy.translation = from_pos

func _on_back_pressed():
	get_tree().change_scene("res://menu.tscn")
