extends HBoxContainer

var hearts_list: Array[TextureRect] = []


func _ready() -> void:
	await get_tree().process_frame
	for child in $".".get_children():
		if child is TextureRect:
			hearts_list.append(child)

	Lives.hearts_changed.connect(update_hearts)
	update_hearts(Lives.hearts)


func update_hearts(current_hearts: int) -> void:
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < current_hearts
