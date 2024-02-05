extends Area2D

@export var speed: float = 300

var direction: Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var velocity = direction * speed *_delta
	global_position += velocity

func set_direction(new_direction: Vector2):
	direction = new_direction
