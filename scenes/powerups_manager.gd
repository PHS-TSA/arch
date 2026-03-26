extends VBoxContainer

var children: Array[Control] = []


func _ready() -> void:
	for i in range(self.get_child_count() - 1, -1, -1):
		children.append(self.get_child(i))
	for child in self.get_children():
		child.modulate.a = 0


func _on_powerup_used(powerup: Inventory.Powerup) -> void:
	for child in children:
		if child.modulate.a != 0:
			pass
		else:
			child.fill(powerup)
			break


func _on_character_body_3d_jump_power() -> void:
	for child in self.get_children():
		if child.get_child(0).frame == 3:
			child.get_child(1).get_child(0).stop()
