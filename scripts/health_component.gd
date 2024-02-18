extends Node2D
## Node that handles the health of an entity.

signal damage_taken ## called when an entity takes damage.
signal on_death ## called when an entitie's health reaches 0.

@export var health: float = 100.0

var current_health: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = health
	pass # Replace with function body.

## Harms the entity by a given amount. Calls [signal damage_taken] or [signal on_death] if health reaches 0
## [br]
## [param damage] : amount of damage to take.
func take_damage(damage: float):
	current_health -= damage
	damage_taken.emit()
	if(current_health <= 0):
		on_death.emit()

func reset():
	current_health = health