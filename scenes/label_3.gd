extends Label

func _ready() -> void:
	text = "%s, Level %d" % [Lives.get_time(), Inventory.level]
