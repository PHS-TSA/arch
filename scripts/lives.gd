extends Node

signal hearts_changed(new_hearts)
signal game_over(check)

var max_hearts: int = 3
var hearts: int = max_hearts

func take_damage():
	if hearts > 0: 
		hearts -= 1
		emit_signal("hearts_changed", hearts) 
	if hearts == 0:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		hearts = max_hearts 

func heal():
	if hearts < 3:
		hearts += 1
		emit_signal("hearts_changed", hearts)
		
