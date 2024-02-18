extends StaticBody2D
## Obstacle shown as a crow. Player cant get through them.

var target : Node2D

func _ready():
    $AnimationPlayer.play("idle")
    
## Configures the obstacle.
## [br]
## [param pos] : position the obstacle will take. [br]
## [param _target] : optional object that the obstacle will look at.
func setup(pos: Vector2, _target: Node2D = null):
    target = _target
    global_position = pos

## Sets global position of the obstacle.
## [br]
## [param pos] : new position.
func set_pos(pos: Vector2):
    global_position = pos

func _physics_process(_delta):
    if(target != null):
        # rotation = global_position.direction_to(target.position).angle()
        look_at(target.global_position)

## Toggles the obstacle on and off
## [br]
## [param value] : True to enable, false otherwise.
func toggle(value : bool):
    visible = value
    $CollisionShape2D.set_deferred("disabled",not value)