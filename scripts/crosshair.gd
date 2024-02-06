extends Node2D

@export var crosshair: Texture
@export var crosshair_hit: Texture
@export var hit_time: float = 0.02

var hit_registered: bool = false
var current_hit_time: float = 0

func _ready():
	toggle_normal()
	
func toggle_hit():
	Input.set_custom_mouse_cursor(crosshair_hit)
	hit_registered = true
	# $AnimationPlayer.play("hit_animation")

func toggle_normal():
	Input.set_custom_mouse_cursor(crosshair)
	hit_registered = false

func _process(delta):
	if(hit_registered):
		current_hit_time += delta
		if(current_hit_time > hit_time):
			toggle_normal()
			current_hit_time = 0