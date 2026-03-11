extends Node3D

var opened: bool = false

func _on_desert_chest_chest_opened(body: Node3D) -> void:
	if body is Player:
		if opened:
			return
		opened = true
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_EXPO)
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(
			self.get_parent(),
			"rotation:z",
			deg_to_rad(135),
			0.2,
		)


func _on_desert_chest_powerup_collected() -> void:
	await get_tree().create_timer(0.25).timeout
	var tween2 := create_tween()
	tween2.set_trans(Tween.TRANS_EXPO)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_property(
		self.get_parent(),
		"rotation:z",
		0,
		0.2,
	)
