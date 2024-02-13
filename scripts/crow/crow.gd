extends CharacterBody2D

@export var health: Node2D
@export var attack_damage: float = 20

var player: Node
var index : int = 0
signal death

func _ready():
	player = get_tree().get_first_node_in_group("player")
	$Hitbox.monitoring = false

func take_damage(damage: float):
	health.take_damage(damage)

func _on_health_component_on_death():
	death.emit()
	$CollisionShape2D.set_deferred("disabled",true)
	$StateMachine.transition_to("DeathState")

func _on_attack_detect_zone_body_entered(_body):
	if(_body.is_in_group("player")):
		$StateMachine.transition_to("AttackState")
		pass

func _on_hitbox_body_entered(body:Node2D):
	if(body.is_in_group("player")):
		body.take_damage(attack_damage)

func get_animation_player():
	return $AnimationPlayer

func get_player():
	return player

func _on_attack_detect_zone_body_exited(body:Node2D):
	if(body.is_in_group("player")):
		$StateMachine.transition_to("MoveState")

func do_dive():
	$StateMachine.transition_to("DiveState")

func die():
	queue_free()