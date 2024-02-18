extends Area2D
## Object that represents a bullet.

@export var speed: float = 300
@export var time_alive: float = 8.0 ## The time in seconds a bullet can be alive.
@export var damage: float = 100

signal on_hit ## Signal emmited when the bullet hits a valid body.

var direction: Vector2 = Vector2.ZERO
var current_time_alive: float = 0.0

var has_hit_body: bool = false

func _ready():
	# on_hit.connect(MouseManager._on_bullet_hit)
	pass

func _process(_delta):
	var velocity = direction * speed *_delta
	global_position += velocity
	
	if(current_time_alive > time_alive):
		queue_free()

## Sets the direction the bullet will take
## [br]
## [param new_direction] : direction to travel to.
func set_direction(new_direction: Vector2):
	direction = new_direction
	rotation = direction.angle()

# Detects a body when it collides with bullet and attempts to do damage to it.
func _on_body_entered(body:Node2D):
	if(body.has_method("take_damage")):
		if(has_hit_body):
			return
		has_hit_body = true
		body.take_damage(damage)
		on_hit.emit()
	queue_free()
