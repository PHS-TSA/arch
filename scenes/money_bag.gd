extends Area3D

signal moneyBag
const MIN_TWEEN_SCALE := Vector3(0.001, 0.001, 0.001)
var time: float
var cloned := false

func _ready() -> void:
	time = 0

func _process(delta: float) -> void:
	time += delta
	if time > 15:
		create_clone()
		time = 0


func create_clone() -> void:
	var copy: Area3D = self.duplicate()
	copy.cloned = true
	copy.position.y = 0
	get_parent().add_child(copy)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
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
		moneyBag.emit()
		await get_tree().create_timer(1.0).timeout
		self.queue_free()
