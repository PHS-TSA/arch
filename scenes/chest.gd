extends Area3D

var _is_initialized: bool = false

func _ready() -> void:
	_is_initialized = true

func _on_body_entered(body: Node3D) -> void:
	if _is_initialized and body.is_in_group("player"):
		print("chest")
		$powerUp.visible = true
		$powerUp/MeshInstance3D.visible = true


func _on_power_up_body_entered(body: Node3D) -> void:
	self.queue_free()
