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


func _on_powerup_collected(powerup: PowerUp) -> void:
	inventory.append(powerup)
