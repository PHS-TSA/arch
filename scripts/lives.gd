extends Node

signal hearts_changed(new_hearts: int)

const MAX_HEARTS := 3

var hearts := MAX_HEARTS


func take_damage() -> void:
	if hearts > 0:
		hearts -= 1
		hearts_changed.emit(hearts)
	if hearts == 0:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().call_deferred(
			"change_scene_to_file",
			"res://scenes/game_over.tscn",
		)
		hearts = MAX_HEARTS


func heal() -> void:
	if hearts < MAX_HEARTS:
		hearts += 1
		hearts_changed.emit(hearts)
