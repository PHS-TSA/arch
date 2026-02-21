extends Node3D

const POWER_UPS = ["freeze", "speed", "slow", "jump", "shoot"]
var inventory = [] # Tanish you can decide the inventory stuff but I made it a list that it's just putting stuff into now

func _process(delta):
	print("FPS: %s" % Engine.get_frames_per_second())
	print("TPS: %s" % Engine.physics_ticks_per_second)
	print("FDT: %s" % Engine.get_frames_drawn())
