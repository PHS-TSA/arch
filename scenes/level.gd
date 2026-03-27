extends Label

func _ready() -> void:
	pass

func _on_timer_2_timeout() -> void:
	self.text = "Level " + str(Inventory.level)
