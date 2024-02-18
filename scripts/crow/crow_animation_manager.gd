extends Node

## Object that transitions between different enemy animations.

@export var animation_player : AnimationPlayer

func move():
    animation_player.play("move")

func attack():
    animation_player.play("attack")

func die():
    animation_player.play("die")