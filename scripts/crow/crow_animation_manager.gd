extends Node

@export var animation_player : AnimationPlayer

func move():
    animation_player.play("move")

func attack():
    animation_player.play("attack")