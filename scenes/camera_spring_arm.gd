extends SpringArm3D

@export var mouse_sensibility: float = 0.005


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_event: InputEventMouseMotion = event

		rotation.y -= mouse_event.relative.x * mouse_sensibility

		rotation.x -= mouse_event.relative.y * mouse_sensibility
		rotation.x = clamp(
			rotation.x - mouse_event.relative.y * mouse_sensibility,
			deg_to_rad(-89),
			deg_to_rad(89),
		)

	if event.is_action_pressed("toggle_mouse_capture"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
