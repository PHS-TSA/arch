extends Area3D

var power
var collected: bool = false

func _ready() -> void:
	power = Global.POWER_UPS.pick_random()


func _on_body_entered(body: Node3D) -> void:
	if collected:
		return
	collected = true
	monitoring = false
	visible = false
	Global.inventory.append(power)
