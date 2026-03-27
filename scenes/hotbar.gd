class_name Hotbar
extends HBoxContainer

signal powerup_used(powerup: Inventory.Powerup)
signal no_pickup
signal pickup

var contains: Array[bool] = []
var selected: int
var no_pick := false

@onready var ogstyle: StyleBoxFlat = (
	get_child(0).find_child("Panel").get_theme_stylebox("panel").duplicate()
)
@onready var newstyle: StyleBoxFlat = ogstyle.duplicate()


func _ready() -> void:
	newstyle.bg_color = Color(0.725, 0.701, 0.0, 0.6)
	for i in range(get_child_count()):
		contains.append(false)
	for child in get_children():
		child.no_pickup.connect(_on_last_slot_no_pickup)
	selected = 0
	get_child(selected).find_child("Panel").add_theme_stylebox_override("panel", newstyle)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var e := event as InputEventKey
		var number_pressed := -1
		if e.keycode >= KEY_0 and e.keycode <= KEY_9:
			number_pressed = event.keycode - KEY_0
			number_pressed = number_pressed - 1
			if number_pressed == -1:
				number_pressed = 9
			if number_pressed >= get_child_count():
				number_pressed = -2
			if number_pressed != -2:
				for child in get_children():
					child.find_child("Panel").add_theme_stylebox_override("panel", ogstyle)
				get_child(number_pressed).find_child("Panel").add_theme_stylebox_override(
					"panel",
					newstyle,
				)
				selected = number_pressed
		elif event.keycode == KEY_E:
			if selected < 0 or selected >= get_child_count():
				return
			if contains[get_child(selected).get_index()]:
				powerup_used.emit(get_child(selected).empty())
				no_pick = false
				pickup.emit()


func _on_powerup_collected(powerup: Inventory.Powerup) -> void:
	var next_index: int
	for i in range(len(contains) - 1, -1, -1):
		if not contains[i]:
			next_index = i

	if next_index == null or next_index >= get_child_count():
		return
	get_child(next_index).fill(powerup)


func _on_last_slot_no_pickup() -> void:
	no_pick = true
	no_pickup.emit()
