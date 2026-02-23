extends Area3D

signal power_up_collected(power_up: Inventory.PowerUp)

var powerup: Inventory.PowerUp
var collected: bool = false


func _ready() -> void:
	powerup = Inventory.PowerUp.values().pick_random()


func _on_body_entered(body: Node3D) -> void:
	if collected:
		return
	if not body is Player:
		return

	collected = true
	monitoring = false
	visible = false
	power_up_collected.emit(powerup)
