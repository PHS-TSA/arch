extends HBoxContainer

var hearts_list: Array[TextureRect] = []


func _ready() -> void:
	hearts_list.clear()
	for node in find_children("*", "TextureRect", true, false):
		if node is TextureRect:
			hearts_list.append(node)

	if not Lives.hearts_changed.is_connected(update_hearts):
		Lives.hearts_changed.connect(update_hearts)
	update_hearts(Lives.hearts)


func update_hearts(current_hearts: int) -> void:
	var clamped_hearts := clampi(current_hearts, 0, hearts_list.size())
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < clamped_hearts
