extends Sprite2D

signal hide

var colors := [
	Color(0.514, 0.784, 1.0, 1.0),
	Color(1, 1, 0, 1),
	Color(0, 1, 0, 1),
	Color(0, 0, 1, 1),
	Color(1, 0, 0, 1),
]
var process := false

@onready var atlas := AtlasTexture.new()
@onready var og := load("res://assets/2d/powerup_outline.png")
@onready var y: int
@onready var timer: Timer = $Timer


func _process(_delta: float) -> void:
	if process:
		atlas.atlas = og
		y = int((1.0 - timer.time_left / timer.wait_time) * 400)
		atlas.region = Rect2(0, y, 400, 400 - y)
		self.position.y = y * 0.15
		self.texture = atlas
		if timer.is_stopped():
			process = false
			hide.emit()


func fill(powerup: Inventory.Powerup) -> void:
	self.modulate = colors[powerup]

	timer.wait_time = 2.5 if powerup < 3 else 9223372036854775807.
	timer.start()

	process = true
