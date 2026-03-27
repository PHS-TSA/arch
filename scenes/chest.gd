class_name Chest
extends Area3D

signal powerup_collected(powerup: Inventory.Powerup)
signal chest_opened

const MIN_TWEEN_SCALE := Vector3(0.001, 0.001, 0.001)

static var occupied: Array[bool] = []

var cloned := false
var time: int = 0
var random: float
var positions: Array[Vector3] = [
	Vector3(3.0, -0.25, -5.5),
	Vector3(-4.25, -0.25, -3.25),
	Vector3(-4.25, -0.25, 2.),
	Vector3(3.25, -0.25, 2.75),
	Vector3(3.25, -0.25, 6.3),
	Vector3(-6.35, -0.25, 8.0),
	Vector3(3.6, -0.25, 9.5),
	Vector3(-9.9, -0.25, -5.70),
	Vector3(8.5, -0.25, -10.),
]

@onready var hotbar: Hotbar = get_parent().find_child("CanvasLayer").find_child("Hotbar")


func _ready() -> void:
	if not self.cloned:
		await get_tree().process_frame
		random = randf_range(180, 1800)
		occupied.clear()
		occupied.resize(positions.size())
		for i in range(positions.size()):
			occupied[i] = false


func _process(_delta: float) -> void:
	if not self.cloned:
		time += 1
		if time > random:
			create_clone()
			time = 0


func on_hotbar_no_pickup() -> void:
	$Powerup.pickup = false


func on_hotbar_pickup() -> void:
	$Powerup.pickup = true


func create_clone() -> void:
	var open_indices: Array[int] = []
	for i in range(positions.size()):
		if i < occupied.size() and not occupied[i]:
			open_indices.append(i)

	if open_indices.is_empty():
		return

	var copy: Chest = self.duplicate()
	var picked_index: int = open_indices.pick_random()
	copy.position = positions[picked_index]
	copy.occupied = self.occupied
	occupied[picked_index] = true
	copy.cloned = true
	get_parent().add_child(copy)
	hotbar.no_pickup.connect(copy.on_hotbar_no_pickup)
	hotbar.pickup.connect(copy.on_hotbar_pickup)


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		chest_opened.emit()
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)


func _on_powerup_collected(powerup: Inventory.Powerup) -> void:
	powerup_collected.emit(powerup)
	await get_tree().create_timer(0.3).timeout
	var tween := create_tween()
	var tween2 := create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(
		self,
		"scale",
		MIN_TWEEN_SCALE,
		1.0,
	)
	tween2.set_trans(Tween.TRANS_BACK)
	tween2.set_ease(Tween.EASE_IN)
	tween2.tween_property(
		self,
		"rotation:y",
		20,
		1.0,
	)
	await get_tree().create_timer(1.0).timeout
	if cloned:
		var idx := positions.find(position)
		if idx != -1 and idx < occupied.size():
			occupied[idx] = false
	self.queue_free()
