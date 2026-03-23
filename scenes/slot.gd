extends Control

signal no_pickup
var held: Inventory.Powerup

func fill(powerup: Inventory.Powerup) -> void:
	$Panel/Powerup_Image.visible = true
	$Panel/Powerup_Image.frame = powerup
	held = powerup
	get_parent().contains[get_index()] = true
	if get_index() == 4:
		no_pickup.emit()

func empty() -> Inventory.Powerup:
	$Panel/Powerup_Image.visible = false
	get_parent().contains[get_index()] = false
	return held
