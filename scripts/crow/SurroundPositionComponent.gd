extends Node
## Component that helps enemies surround an entity.

@export var surround_radius: float = 20 ## Radius around the entity to surround.

var random_angle : float
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
    rng.randomize()
    random_angle = rng.randf_range(-1,1)
    pass

## Returns a random position around an entity.
## [br]
## [param target] : the target to surround. [br]
func get_random_circle_position(target: Vector2) -> Vector2:
    
    var angle = random_angle * PI * 2

    var x = target.x + cos(angle) * surround_radius
    var y = target.y + sin(angle) * surround_radius

    return Vector2(x,y)