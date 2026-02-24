extends Area3D

signal power_up_collected(power_up: Inventory.PowerUp)
signal chest_opened


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		chest_opened.emit()
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)


func _on_power_up_collected(power_up: Inventory.PowerUp) -> void:
	power_up_collected.emit(power_up)
	self.queue_free()
