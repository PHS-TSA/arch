extends Area3D

var cloned := false

func _on_hotbar_powerup_used(powerup: Inventory.Powerup) -> void:
	if powerup == Inventory.Powerup.SHOOT:
		var copy: Area3D = self.duplicate()
		copy.cloned = true
		copy.visible = true
		get_parent().add_child(copy)
		copy.position = get_parent().find_child("CharacterBody3D").position

func _process(delta: float) -> void:
	if cloned:
		self.position.x += cos(self.rotation.y)
		self.position.z += sin(self.rotation.y)

func _on_body_entered(body: Node3D) -> void:
	if body is Bull or body is GameMap:
		if body is Bull:
			body.position = body.starting_pos
		self.queue_free()
