extends Control

func fill(powerup: Inventory.Powerup) -> void:
	self.modulate.a = 1.0
	$Powerup_Indication.frame = powerup
	$Powerup_Time.fill(powerup)


func _on_powerup_time_hide() -> void:
	self.modulate.a = 0.0
