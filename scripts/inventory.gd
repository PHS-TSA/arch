class_name Inventory
extends Object

enum PowerUp {
	FREEZE,
	SPEED,
	SLOW,
	JUMP,
	SHOOT,
}

var inventory: Array[PowerUp] = []


func _on_power_up_collected(power_up: PowerUp) -> void:
	inventory.append(power_up)
