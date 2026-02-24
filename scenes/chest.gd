extends Area3D

signal powerup_collected(powerup: Inventory.PowerUp)
signal chest_opened


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		chest_opened.emit()
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)


func _on_powerup_collected(powerup: Inventory.PowerUp) -> void:
	powerup_collected.emit(powerup)
	self.queue_free()
