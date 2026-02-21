extends Node3D


func _on_chest_body_entered(body: Node3D) -> void:
	for i in range(135):
		self.rotation.x -= deg_to_rad(1)
		print()
		await get_tree().create_timer(0.001).timeout 
