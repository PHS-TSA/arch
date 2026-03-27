extends Label

func _ready() -> void: self.text = "Level " + str(Inventory.level)

func _on_timer_2_timeout() -> void:
	self.text = "Level " + str(Inventory.level)
