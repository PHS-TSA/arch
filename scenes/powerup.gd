extends Area3D

signal powerup_collected(powerup: Inventory.Powerup)

var collected: bool = false
var tween := create_tween()
var tween2 := create_tween()

@onready var powerup: Inventory.Powerup = Inventory.Powerup.values().pick_random()
@onready var horseshoe: Node3D = $horseShoe


func _process(_delta: float) -> void:
	horseshoe.rotation.y += deg_to_rad(1)


func reveal() -> void:
	visible = true
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)


func _on_body_entered(body: Node3D) -> void:
	if collected or (not pickup) or (not body is Player):
		return
	collected = true
	set_deferred("monitoring", false)
	powerup_collected.emit(powerup)

	tween2.set_trans(Tween.TRANS_EXPO)
	tween2.set_ease(Tween.EASE_IN)
	tween2.tween_property($horseShoe/Circle, "scale", Vector3(1.25, 1.25, 1.25), 0.3)
