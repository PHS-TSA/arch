extends Area3D

signal powerup_collected(powerup: Inventory.Powerup)
signal chest_opened
var cloned := false

func _ready() -> void:
	await get_tree().process_frame
	var hotbar = get_parent().find_child("CanvasLayer").find_child("Hotbar")
	if not cloned:
		for i in range(9):
			var copy := self.duplicate()
			copy.position = Vector3(randf_range(-3, 16), self.position.y, randf_range(-2.5, 7.05))
			copy.cloned = true
			get_parent().add_child(copy)
			hotbar.no_pickup.connect(copy._on_hotbar_no_pickup)
			hotbar.pickup.connect(copy._on_hotbar_pickup)

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
		Vector3(0,0,0),
		1.0
	)
	tween2.set_trans(Tween.TRANS_BACK)
	tween2.set_ease(Tween.EASE_IN)
	tween2.tween_property(
		self,
		"rotation:y",
		20,
		1.0
	)
	await get_tree().create_timer(1.0).timeout
	self.queue_free()

func _on_hotbar_no_pickup() -> void:
	$Powerup.pickup = false

func _on_hotbar_pickup() -> void:
	$Powerup.pickup = true
