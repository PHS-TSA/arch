extends Control


func _on_start_pressed() -> void:
	Inventory.level = 1
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://instructions.tscn")
