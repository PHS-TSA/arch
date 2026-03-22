class_name Inventory
extends Object

enum Powerup {
	FREEZE,
	SPEED,
	SLOW,
	JUMP,
	SHOOT,
}

var inventory: Array[Powerup] = []

func _on_powerup_collected(powerup: Powerup) -> void:
	inventory.append(powerup)
