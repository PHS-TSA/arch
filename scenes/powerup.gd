extends Area3D

signal powerup_collected(powerup: Inventory.Powerup)

var powerup: Inventory.Powerup
var collected: bool = false


func _ready() -> void:
	powerup = Inventory.Powerup.values().pick_random()


func reveal() -> void:
	visible = true
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)


func _on_body_entered(body: Node3D) -> void:
	if collected:
		return
	if not body is Player:
		return
	collected = true
	set_deferred("monitoring", false)
	visible = false
	powerup_collected.emit(powerup)
