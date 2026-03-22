class_name Player
extends CharacterBody3D
#.
@onready var stamina_bar: ProgressBar = %Stamina_Bar
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const LERP_SPEED = 10.0 

var max_speed = 5
var sprint_speed = 8
var walk_speed = 5

var stamina: float = 50.0
var max_stamina: float = 50.0
var stamina_drain: float = 20.0
var stamina_regen: float = 10.0

var is_exhausted: bool = false
var recovery_threshold: float = 20.0

var jump_mult = 1.0
signal jump_power

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * jump_mult
		if jump_mult != 1.0:
			jump_mult = 1.0
			jump_power.emit()
		
	if Input.is_action_pressed("sprint"):
		max_speed = sprint_speed
	else:
		max_speed = walk_speed

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var look_direction = spring_arm_3d.global_transform.basis
	var direction := (look_direction * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0 
	
	
	if stamina <= 0:
		is_exhausted = true
		
	
	if is_exhausted and stamina >= recovery_threshold:
		is_exhausted = false

	
	if not is_exhausted and Input.is_action_pressed("sprint") and direction != Vector3.ZERO:
		max_speed = sprint_speed
		stamina -= stamina_drain * delta
	else:
		max_speed = walk_speed
		stamina += stamina_regen * delta
	
	stamina = clamp(stamina, 0, max_stamina)
	
	if direction:
		velocity.x = direction.x * max_speed
		velocity.z = direction.z * max_speed
	
		var target_angle = atan2(direction.x, direction.z)
		mesh_instance_3d.rotation.y = lerp_angle(mesh_instance_3d.rotation.y, target_angle, delta * LERP_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, max_speed)
		velocity.z = move_toward(velocity.z, 0, max_speed)

	if stamina_bar:
		stamina_bar.value = stamina
		
		if is_exhausted:
			stamina_bar.modulate = Color.RED
		else:
			stamina_bar.modulate = Color.WHITE

	move_and_slide()
	


func _on_powerup_used(powerup: Inventory.Powerup) -> void:
	if powerup == 1:
		walk_speed *= 2
		sprint_speed *= 2
		await get_tree().create_timer(2.5).timeout
		walk_speed /= 2
		sprint_speed /= 2
	elif powerup == 3:
		jump_mult = 1.5
