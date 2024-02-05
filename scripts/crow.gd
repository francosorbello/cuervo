extends CharacterBody2D

const SPEED = 300.0

@export var health: Node2D

func take_damage(damage: float):
	health.take_damage(damage)

func _on_health_component_on_death():
	queue_free()
