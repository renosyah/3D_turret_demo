extends Node

export var enemy_scene :PackedScene

onready var spawn = $Path/spawn
onready var to = $Path2/to
onready var timer = $Timer
onready var label = $CanvasLayer/Label

var killed :int
var escape :int

func _ready():
	timer.start()
	print_label()
	
func _on_Timer_timeout():
	timer.start()
	
	spawn.unit_offset = randf()
	to.unit_offset = randf()
	
	var from_pos = spawn.global_transform.origin + (Vector3.UP * rand_range(-2, 2))
	var move_to = to.global_transform.origin
	
	var enemy = enemy_scene.instance()
	enemy.move_to = move_to
	enemy.connect("reach", self, "_on_enemy_reach")
	enemy.connect("killed", self,"_on_enemy_killed")
	add_child(enemy)
	enemy.translation = from_pos

func _on_back_pressed():
	get_tree().change_scene("res://menu.tscn")

func _on_enemy_reach():
	escape += 1
	print_label()
	
func _on_enemy_killed():
	killed += 1
	print_label()
	
func print_label():
	label.text = "Killed : %s\nEscape : %s\nSuccess Ratio : %s" % [killed, escape, get_kill_ratio(killed, escape)]
	
func get_kill_ratio(killed: int, escaped: int) -> float:
	var total = killed + escaped
	if total == 0:
		return 0.0
	return round(float(killed) / float(total) * 100.0)
