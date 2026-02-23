extends CollisionShape3D

func _on_chest_body_entered(body: Node3D) -> void:
	self.queue_free()
