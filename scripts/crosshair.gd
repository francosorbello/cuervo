extends Node2D
## Custom crosshair for the game.

@export var crosshair: Texture ## Texture for the crosshair.
@export var crosshair_hit: Texture ## Texture for when the player hits an enemy.
@export var hit_time: float = 0.02

var hit_registered: bool = false
var current_hit_time: float = 0

func _ready():
	toggle_normal()

## Displays the hit crosshair.
func toggle_hit():
	Input.set_custom_mouse_cursor(crosshair_hit)
	hit_registered = true
	# $AnimationPlayer.play("hit_animation")

## Displays the aim crosshair.
func toggle_normal():
	Input.set_custom_mouse_cursor(crosshair)
	hit_registered = false

func _process(delta):
	if(hit_registered):
		current_hit_time += delta
		if(current_hit_time > hit_time):
			toggle_normal()
			current_hit_time = 0