extends Node

@export var surround_radius: float = 20

var random_angle : float
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
    rng.randomize()
    random_angle = rng.randf_range(-1,1)
    pass

func get_random_circle_position(target: Vector2, do_randomize: bool = false) -> Vector2:
    
    if do_randomize:
        rng.randomize()
        random_angle = rng.randf_range(-1,1)

    var angle = random_angle * PI * 2

    var x = target.x + cos(angle) * surround_radius
    var y = target.y + sin(angle) * surround_radius

    return Vector2(x,y)