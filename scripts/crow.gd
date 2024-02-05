extends CharacterBody2D

@export var speed: float = 50
@export var health: Node2D

var player: Node

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	velocity = global_position.direction_to(player.global_position)
	move_and_collide(velocity*speed*delta)
	look_at(player.global_position)

func take_damage(damage: float):
	health.take_damage(damage)

func _on_health_component_on_death():
	queue_free()
