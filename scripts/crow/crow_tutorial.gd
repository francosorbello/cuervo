extends StaticBody2D
## Tutorial enemy that only takes damage. It also blocks player pasage.

var damaged : bool = false

func _ready():
    $AnimationPlayer.play("tutorial_idle")
    pass

## Does damage to the enemy.
## [br]
func take_damage(_damage):
    if damaged:
        return
    damaged = true
    $CollisionShape2D.set_deferred("disabled",true)
    $AnimationPlayer.play("tutorial_die")

## Destroys the enemy.
func die():
    queue_free()