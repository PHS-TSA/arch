extends Control

signal no_pickup
var held: Inventory.Powerup
var holding := false

func fill(powerup: Inventory.Powerup) -> void:
	$Panel/Powerup_Image.visible = true
	holding = true
	held = powerup
	get_parent().not_contains_except.erase(get_index())
	if get_index() == 4:
		no_pickup.emit()

func empty() -> Inventory.Powerup:
	$Panel/Powerup_Image.visible = false
	holding = false
	return held
