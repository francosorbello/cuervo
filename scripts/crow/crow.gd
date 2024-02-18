extends CharacterBody2D
## Enemy the player fights.
##
## Enemies are controlled via a state machine.


@export var health: Node2D ## Component that manages enemy health.
@export var attack_damage: float = 20
@export var start_idle: bool = false ## Will start on idle state if true.

var player: Node
var index : int = 0

signal death ## Signal emmited when the crow dies.

func _ready():
	player = get_tree().get_first_node_in_group("player")
	$Hitbox.monitoring = false # workaround wierd godot bug where hitbox is set to monitoring when loading scene.
	if(start_idle):
		$StateMachine.transition_to("IdleState")


## Does damage to the enemy.
## [br]
## [param damage] : amount of damage the enemy takes. [br]
func take_damage(damage: float):
	health.take_damage(damage)

# Destroys the enemy when health reaches 0.
func _on_health_component_on_death():
	death.emit()
	$CollisionShape2D.set_deferred("disabled",true)
	$StateMachine.transition_to("DeathState")

# Transitions to attack state when player is on attack range.
func _on_attack_detect_zone_body_entered(_body):
	if(_body.is_in_group("player")):
		$StateMachine.transition_to("AttackState")
		pass

# Attacks the player when in range.
func _on_hitbox_body_entered(body:Node2D):
	if(body.is_in_group("player")):
		body.take_damage(attack_damage)

## Returns the enemy animation player. See [i]crow_animation_player.gd[/i]
func get_animation_player():
	return $AnimationPlayer

## Returns the target player.
func get_player():
	return player

# Transitions to moving when the player is not on attack range.
func _on_attack_detect_zone_body_exited(body:Node2D):
	if(body.is_in_group("player")):
		$StateMachine.transition_to("MoveState")

## Transitions to Dive state.
func do_dive():
	$StateMachine.transition_to("DiveState")

## Destroys the enemy.
func die():
	queue_free()
