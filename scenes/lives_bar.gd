extends HBoxContainer

var hearts_list : Array[TextureRect] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in $".".get_children():
		if child is TextureRect:
			hearts_list.append(child)
		
	Lives.hearts_changed.connect(update_hearts)
	update_hearts(Lives.hearts)

func update_hearts(current_hearts: int) -> void:
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < current_hearts
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
