extends Label

var seconds_left := 30

func _ready() -> void:
	update_text()

func _on_timer_2_timeout() -> void:
	seconds_left -= 1
	if seconds_left <= 0:
		seconds_left = 0
		update_text()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
		return

	update_text()

func update_text() -> void:
	var minutes = seconds_left / 60
	var seconds = seconds_left % 60
	text = str(minutes) + ":" + str(seconds).pad_zeros(2)
	Lives.set_time(text)
