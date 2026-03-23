extends Area3D


func _on_body_entered(body: Node3D) -> void:
	print("entered:", body)
	if body is Player:
		Lives.heal()
