extends HBoxContainer

signal powerup_used(powerup: Inventory.Powerup)
var contains: int = -1
var not_contains_except: Array[int] = []
var selected: int
var ogstyle: StyleBox
var newstyle: StyleBox

func _ready() -> void:
	await get_tree().process_frame
	ogstyle = get_child(0).find_child("Panel").get_theme_stylebox("panel").duplicate()
	newstyle = ogstyle.duplicate()
	newstyle.bg_color = Color(0.725, 0.701, 0.0, 0.6)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var number_pressed := -1
		if event.keycode >= KEY_0 and event.keycode <= KEY_9:
			number_pressed = event.keycode - KEY_0
			number_pressed = number_pressed - 1
			if number_pressed == -1:
				number_pressed = 9
			if number_pressed >= get_child_count():
				number_pressed = -2
			if number_pressed != -2:
				for child in get_children():
					child.find_child("Panel").add_theme_stylebox_override("panel", ogstyle)
				get_child(number_pressed).find_child("Panel").add_theme_stylebox_override("panel", newstyle)
				selected = number_pressed
		elif event.keycode == KEY_E:
			if get_child(selected).holding:
				powerup_used.emit(get_child(selected).empty())
				for i in range(get_child_count() - 1, -1, -1):
					if get_child(i).holding:
						contains = i
						break
					contains = -1
				if contains > selected:
					not_contains_except.append(selected)

func _on_powerup_collected(powerup: Inventory.Powerup) -> void:
	var next_index := 0
	next_index = contains + 1
	
	while next_index < get_child_count() and next_index in not_contains_except:
		next_index += 1
	if next_index >= get_child_count():
		return
	get_child(next_index).fill(powerup)
	
	contains = next_index
