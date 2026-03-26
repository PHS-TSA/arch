extends Node3D

signal chest_opened(body: Node3D)
signal powerup_collected()


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		chest_opened.emit(body)


func _on_powerup_collected(powerup: Inventory.Powerup) -> void:
	powerup_collected.emit()
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
