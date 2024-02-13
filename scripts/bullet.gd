extends Area2D

@export var speed: float = 300
@export var time_alive: float = 8.0
@export var damage: float = 100

signal on_hit()

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

func set_direction(new_direction: Vector2):
	direction = new_direction
	rotation = direction.angle()


func _on_body_entered(body:Node2D):
	if(body.has_method("take_damage")):
		if(has_hit_body):
			return
		has_hit_body = true
		body.take_damage(damage)
		on_hit.emit()
	queue_free()
