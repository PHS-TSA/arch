extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if Time.get_ticks_msec() > 500: # idk why but this has to be there to work
		print("chest")
		$powerUp.visible = true
		$powerUp/MeshInstance3D.visible = true
	#var powerUpNew = $powerUp.duplicate()
	#add_child(powerUpNew)
	#powerUpNew.position += Vector3(5, 0, 0)


func _on_power_up_body_entered(body: Node3D) -> void:
	self.queue_free()
