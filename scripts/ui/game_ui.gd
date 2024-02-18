extends Control

@export var transition_in_speed : float = 1.0
@export var transition_out_speed : float = 1.0

func toggle(value : bool):
    pass

func transition_in():
    return _transition_anim(1,transition_in_speed)

func transition_out():
    return _transition_anim(0,transition_out_speed)

func _transition_anim(transparency_value : float, time : float):
    var tween = get_tree().create_tween()
    return tween.tween_property($TransitionColor,"modulate",Color(1,1,1,transparency_value),time).finished