extends CharacterBody2D

@export var speed: float = 50
@export var health: Node2D
@export var attack_damage: float = 20

var player: Node
var allow_movement: bool = true

func _ready():
	player = get_tree().get_first_node_in_group("player")

# func _physics_process(delta):
# 	look_at(player.global_position)
# 	if(!allow_movement):
# 		return
# 	velocity = global_position.direction_to(player.global_position)
# 	move_and_collide(velocity*speed*delta)

func take_damage(damage: float):
	health.take_damage(damage)

func _on_health_component_on_death():
	queue_free()

func _on_attack_detect_zone_body_entered(_body):
	if(_body.is_in_group("player")):
		$StateMachine.transition_to("AttackState")
		pass

func _on_hitbox_body_entered(body:Node2D):
	if(body.is_in_group("player")):
		body.take_damage(attack_damage)

func toggle_walk():
	enable_movement()

func enable_movement():
	allow_movement = true

func disable_movement():
	allow_movement = false

func get_animation_player():
	return $AnimationPlayer

func get_player():
	return player

func _on_attack_detect_zone_body_exited(body:Node2D):
	if(body.is_in_group("player")):
		toggle_walk()