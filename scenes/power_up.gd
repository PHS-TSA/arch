extends Area3D

var power = Global.POWER_UPS.pick_random()

func _on_body_entered(body: Node3D) -> void:
	if self.visible:
		Global.inventory.append(power)
		print(Global.inventory)
