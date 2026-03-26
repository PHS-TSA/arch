extends CharacterBody3D

enum BullType {
	RED,
	PINK,
	CYAN,
	ORANGE,
	GREEN,
}

@export var bull_type: BullType = BullType.RED
@export var bull_color: Color = Color(1.0, 0.21568628, 0.21176471, 1.0)
@export_range(0.5, 10.0, 0.1) var move_speed: float = 2.5
@export_range(0.1, 5.0, 0.1) var retarget_interval: float = 0.4
@export_range(0.5, 8.0, 0.1) var prediction_distance: float = 3.0
@export_range(1.0, 10.0, 0.1) var flee_distance: float = 5.0
@export_range(0.2, 5.0, 0.1) var teleport_interval: float = 10.
@export_range(0.5, 6.0, 0.1) var teleport_radius_min: float = 1.4
@export_range(1.0, 8.0, 0.1) var teleport_radius_max: float = 3.0
@export_range(0.5, 4.0, 0.1) var min_safe_teleport_distance: float = 1.2

var player: Player
var retarget_cooldown: float = 0.0
var teleport_cooldown: float = 0.0
var current_target_position: Vector3 = Vector3.ZERO

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var mesh_instance_3d: MeshInstance3D = $CollisionShape3D/MeshInstance3D


func _ready() -> void:
	_apply_color()
	navigation_agent.set_navigation_map(get_world_3d().navigation_map)
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	retarget_cooldown = randf_range(1., retarget_interval)
	teleport_cooldown = randf_range(1., teleport_interval)
	actor_setup.call_deferred()


func _physics_process(delta: float) -> void:
	_ensure_player()
	if player == null:
		velocity = Vector3.ZERO
		move_and_slide()
		return

	if bull_type == BullType.GREEN:
		_process_green(delta)
		return

	_process_navigation(delta)


func actor_setup() -> void:
	await get_tree().physics_frame
	player = _get_player()
	if bull_type != BullType.GREEN:
		_retarget()


func _process_navigation(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0.0

	retarget_cooldown -= delta
	if retarget_cooldown <= 0.0:
		_retarget()
		retarget_cooldown = retarget_interval

	var movement_target: Vector3 = _get_movement_target()
	var horizontal_offset := movement_target - global_position
	horizontal_offset.y = 0.0
	if horizontal_offset.length() <= navigation_agent.target_desired_distance:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)
	else:
		var direction: Vector3 = horizontal_offset.normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed

	move_and_slide()


func _process_green(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0.0

	velocity.x = 0.0
	velocity.z = 0.0

	teleport_cooldown -= delta
	if teleport_cooldown <= 0.0:
		global_position = _find_green_teleport_target()
		teleport_cooldown = teleport_interval

	move_and_slide()


func _retarget() -> void:
	current_target_position = _get_target_position()
	navigation_agent.set_target_position(current_target_position)


func _get_target_position() -> Vector3:
	match bull_type:
		BullType.PINK:
			return _get_pink_target()
		BullType.CYAN:
			return _get_cyan_target()
		BullType.ORANGE:
			if randf() < 0.5:
				return _get_flee_target()
			return _get_player_ground_position()
		_:
			return _get_player_ground_position()


func _get_pink_target() -> Vector3:
	var player_velocity: Vector3 = _get_player_velocity_flat()
	if player_velocity.length() < 0.1:
		return _get_player_ground_position()

	return _snap_to_navigation(player.global_position + player_velocity.normalized() * prediction_distance)


func _get_cyan_target() -> Vector3:
	var player_target: Vector3 = _get_player_ground_position()
	var pink_target: Vector3 = _get_pink_target()
	return _snap_to_navigation(player_target.lerp(pink_target, 0.5))


func _get_flee_target() -> Vector3:
	var away_from_player: Vector3 = global_position - _get_player_ground_position()
	away_from_player.y = 0.0
	if away_from_player.length() < 0.1:
		away_from_player = -_get_player_preferred_forward()
	else:
		away_from_player = away_from_player.normalized()

	var angle_offset: float = randf_range(-PI / 3.0, PI / 3.0)
	var flee_direction: Vector3 = away_from_player.rotated(Vector3.UP, angle_offset)
	return _snap_to_navigation(global_position + flee_direction * flee_distance)


func _find_green_teleport_target() -> Vector3:
	var player_position: Vector3 = player.global_position
	var preferred_forward: Vector3 = _get_player_preferred_forward()
	var preferred_right: Vector3 = Vector3.UP.cross(preferred_forward).normalized()
	if preferred_right.length() < 0.1:
		preferred_right = Vector3.RIGHT

	var preferred_directions: Array[Vector3] = [
		preferred_forward,
		(preferred_forward + preferred_right).normalized(),
		(preferred_forward - preferred_right).normalized(),
		preferred_right,
		-preferred_right,
	]

	for direction in preferred_directions:
		var preferred_target: Vector3 = _sample_teleport_target(player_position, direction)
		if _is_valid_green_target(preferred_target, player_position):
			return preferred_target

	for attempt in 8:
		var random_direction := Vector3.FORWARD.rotated(Vector3.UP, randf_range(0.0, TAU))
		var fallback_target: Vector3 = _sample_teleport_target(player_position, random_direction)
		if _is_valid_green_target(fallback_target, player_position):
			return fallback_target

	return global_position


func _sample_teleport_target(player_position: Vector3, direction: Vector3) -> Vector3:
	var rotated_direction := direction.rotated(
		Vector3.UP,
		randf_range(-PI / 8.0, PI / 8.0),
	).normalized()
	var radius := randf_range(teleport_radius_min, teleport_radius_max)
	return _snap_to_navigation(player_position + rotated_direction * radius)


func _is_valid_green_target(candidate: Vector3, player_position: Vector3) -> bool:
	return candidate.distance_to(player_position) >= min_safe_teleport_distance


func _get_player_ground_position() -> Vector3:
	var player_position := player.global_position
	if not _navigation_map_ready():
		return player_position

	return _snap_to_navigation(player_position)


func _get_player_velocity_flat() -> Vector3:
	var player_velocity: Vector3 = player.velocity
	player_velocity.y = 0.0
	return player_velocity


func _get_player_preferred_forward() -> Vector3:
	var player_velocity: Vector3 = _get_player_velocity_flat()
	if player_velocity.length() >= 0.1:
		return player_velocity.normalized()

	var facing: Vector3 = player.get_horizontal_facing()
	if facing.length() >= 0.1:
		return facing

	return Vector3.FORWARD


func _snap_to_navigation(to_point: Vector3) -> Vector3:
	if _navigation_map_ready():
		var navigation_map: RID = navigation_agent.get_navigation_map()
		return NavigationServer3D.map_get_closest_point(navigation_map, to_point)

	return to_point


func _navigation_map_ready() -> bool:
	var navigation_map: RID = navigation_agent.get_navigation_map()
	if not navigation_map.is_valid():
		return false

	return NavigationServer3D.map_get_iteration_id(navigation_map) > 0


func _get_movement_target() -> Vector3:
	if not navigation_agent.is_navigation_finished():
		return navigation_agent.get_next_path_position()

	return current_target_position


func _ensure_player() -> void:
	if is_instance_valid(player):
		return

	player = _get_player()


func _get_player() -> Player:
	var grouped_player := get_tree().get_first_node_in_group("player") as Player
	if grouped_player != null:
		return grouped_player

	var parent_node := get_parent()
	if parent_node == null:
		return null

	var sibling_player := parent_node.get_node_or_null("CharacterBody3D")
	return sibling_player as Player


func _apply_color() -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = bull_color
	mesh_instance_3d.material_override = material


func _on_damage_area_body_entered(body: Node3D) -> void:
	if body is Player:
		Lives.take_damage()
