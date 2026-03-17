extends Area3D

signal powerup_collected(powerup: Inventory.Powerup)

var powerup: Inventory.Powerup
var collected: bool = false

var tween := create_tween()
var tween2 := create_tween()

func _ready() -> void:
	powerup = Inventory.Powerup.values().pick_random()


func reveal() -> void:
	visible = true
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)


func _on_body_entered(body: Node3D) -> void:
	if collected:
		return
	if not body is Player:
		return
	collected = true
	set_deferred("monitoring", false)
	powerup_collected.emit(powerup)
	
	var mesh: MeshInstance3D = $MeshInstance3D
	
	var material: StandardMaterial3D = mesh.get_active_material(0).duplicate()
	mesh.material_override = material
	
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(mesh.get_active_material(0), "albedo_color:a", 0.0, 0.3)
	
	tween2.set_trans(Tween.TRANS_EXPO)
	tween2.set_ease(Tween.EASE_IN)
	tween2.tween_property(mesh, "scale", Vector3(1.25, 1.25, 1.25), 0.3)
