extends CharacterBody2D

@export var speed: float = 50
@export var health: Node2D
@export var attack_damage: float = 20

var player: Node

func _ready():
	player = get_tree().get_first_node_in_group("player")
	$Animations.play("move")

func _physics_process(delta):
	velocity = global_position.direction_to(player.global_position)
	move_and_collide(velocity*speed*delta)
	look_at(player.global_position)

func take_damage(damage: float):
	health.take_damage(damage)

func _on_health_component_on_death():
	queue_free()

func _on_attack_detect_zone_body_entered(_body):
	if(_body.is_in_group("player")):
		$Animations.play("attack")

func _on_hitbox_body_entered(body:Node2D):
	if(body.is_in_group("player")):
		body.take_damage(attack_damage)
