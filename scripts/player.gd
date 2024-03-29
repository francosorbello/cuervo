extends CharacterBody2D
## Player character.
##
## Handles: [br]
## - Movement [br]
## - Shoot [br]
## - Camera

@export_category("Character movement")
@export var speed = 400.0 ## character movement speed
@export_range(0,1,0.2) var movement_deceleration: float = 0.8 ## character movement deceleration
@export_range(0,1,0.2) var aim_deceleration: float = 0.8 ## aim deceleration

@export_category("Attack")
@export var Gun: Marker2D

@export_category("Animation")
@export var hurt_animation_duration : float = 0.2

var previous_motion: Vector2 = Vector2.ZERO
var previous_aim_position: Vector2 
var _controller_enabled : bool = true
var can_take_damage : bool = true
var initial_position : Vector2

signal player_died

func _ready():
	initial_position = global_position

## gets player input and transforms it to velocity
func get_input():
	if(not _controller_enabled):
		return
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = input_dir * speed

func reset():
	global_position = initial_position
	can_take_damage = true
	$PlayerAudioController.reset()
	$HealthComponent.reset()

func _physics_process(delta):
	get_input()

	_handle_movement(delta)
	_handle_aim()

	if(Input.is_action_pressed("attack")):
		_shoot()	

## Handles player movement
func _handle_movement(delta: float):
	if(not _controller_enabled):
		return
	var current_motion: Vector2 = velocity * delta
	current_motion = current_motion.lerp(previous_motion, movement_deceleration)
	
	move_and_collide(current_motion)
	
	previous_motion = current_motion

## handles player aim
func _handle_aim():
	if (not _controller_enabled):
		return
	var current_aim_position: Vector2 = get_global_mouse_position()
	current_aim_position = current_aim_position.lerp(previous_aim_position,aim_deceleration) 
	
	look_at(current_aim_position)
	
	previous_aim_position = current_aim_position

func _shoot():
	if (not _controller_enabled):
		return

	if(Gun != null):
		Gun.shoot(get_global_mouse_position())
	
func take_damage(damage):
	if(not can_take_damage):
		return
	$PlayerAudioController.play_pain_sound()
	$HealthComponent.take_damage(damage)
	_hurt_animation()

func _on_gun_shot_taken():
	$Camera2D.do_shake()
	pass # Replace with function body.

func _toggle_controller():
	_controller_enabled = not _controller_enabled

func enable_controller():
	_controller_enabled = true

func disable_controller():
	_controller_enabled = false

func story_disable_controller():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"velocity",Vector2.ZERO,1)
	disable_controller()

func story_zoom_in():
	$Camera2D.zoom_in()
	$Camera2D.focus_top()

func story_zoom_out():
	$Camera2D.zoom_out()
	$Camera2D.focus_center()

func story_zoom_on(point : Vector2):
	$Camera2D.zoom_in()
	$Camera2D.focus_on(point)

func _on_health_component_on_death():
	$PlayerAudioController.play_death_sound()
	#$Camera2D.zoom_in()
	disable_controller()
	can_take_damage = false
	player_died.emit()
	pass # Replace with function body.

func _hurt_animation():
	$Sprite2D.modulate = Color(1,0,0,1)
	get_tree().create_tween().tween_property($Sprite2D,"modulate",Color.WHITE,hurt_animation_duration)
	