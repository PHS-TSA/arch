extends Node3D

var opened: bool = false


func _on_chest_body_entered(body: Node3D) -> void:
	if body is Player:
		if opened:
			return

		opened = true

		var tween := create_tween()
		tween.tween_property(
			self,
			"rotation:x",
			self.rotation.x - deg_to_rad(135),
			0.135,
		)
