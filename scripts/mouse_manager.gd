extends Node

func _on_bullet_hit():
	$Crosshair.toggle_hit()