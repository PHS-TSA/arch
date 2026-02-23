class_name Inventory
extends Node3D

signal power_up_collected(power_up: PowerUp, items: Array[PowerUp])

enum PowerUp {
	FREEZE,
	SPEED,
	SLOW,
	JUMP,
	SHOOT,
}

var inventory: Array[PowerUp] = []


func add_power_up(power_up: PowerUp) -> void:
	inventory.append(power_up)
	power_up_collected.emit(power_up, inventory.duplicate())


func _on_power_up_collected(power_up: PowerUp) -> void:
	add_power_up(power_up)
