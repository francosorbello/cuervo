extends StaticBody2D

var damaged : bool = false

func _ready():
    $AnimationPlayer.play("tutorial_idle")
    pass

func take_damage(_damage):
    if damaged:
        return
    damaged = true
    $CollisionShape2D.set_deferred("disabled",true)
    $AnimationPlayer.play("tutorial_die")

func die():
    queue_free()