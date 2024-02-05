extends Node2D

signal damage_taken
signal on_death

@export var health: float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(damage: float):
	health -= damage
	if(health <= 0):
		on_death.emit()
