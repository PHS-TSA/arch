extends Area3D

signal power_up_collected(power_up: Inventory.PowerUp)

var _is_initialized: bool = false

@onready var _power_up: Area3D = $powerUp
@onready var _power_up_mesh: MeshInstance3D = $powerUp/MeshInstance3D


func _ready() -> void:
	_is_initialized = true


func _on_body_entered(body: Node3D) -> void:
	if _is_initialized and body is Player:
		_power_up.visible = true
		_power_up_mesh.visible = true


func _on_power_up_collected(power_up: Inventory.PowerUp) -> void:
	power_up_collected.emit(power_up)
	self.queue_free()
