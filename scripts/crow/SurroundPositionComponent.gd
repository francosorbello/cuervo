extends Node

@export var surround_radius: float = 40

var random_angle : float

func _ready():
    var rng = RandomNumberGenerator.new()
    rng.randomize()
    random_angle = rng.randf_range(-1,1)
    pass

func get_circle_position(target: Vector2) -> Vector2:
    var angle = random_angle * PI * 2

    var x = target.x + cos(angle) * surround_radius
    var y = target.y + sin(angle) * surround_radius

    return Vector2(x,y)