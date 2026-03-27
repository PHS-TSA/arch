extends Label

const ROUND_DURATION_SECONDS := 60

var seconds_left := ROUND_DURATION_SECONDS

func _ready() -> void:
	update_text()


func update_text() -> void:
	var minutes := int(seconds_left / 60.0)
	var seconds := seconds_left % 60
	text = str(minutes) + ":" + str(seconds).pad_zeros(2)

	var elapsed_seconds := ROUND_DURATION_SECONDS - seconds_left
	var elapsed_minutes := int(elapsed_seconds / 60.0)
	var elapsed_remainder := elapsed_seconds % 60
	var elapsed_text := str(elapsed_minutes) + ":" + str(elapsed_remainder).pad_zeros(2)
	Lives.set_time(elapsed_text)


func _on_timer_2_timeout() -> void:
	seconds_left -= 1
	if seconds_left <= 0:
		seconds_left = 0
		update_text()
		if Inventory.level < 5:
			Inventory.level += 1
			seconds_left = 60
			update_text()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
			return
	update_text()
