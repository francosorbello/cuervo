extends CharacterBody2D

@export_category("Character movement")
@export var speed = 400.0 ## character movement speed
@export_range(0,1,0.2) var movement_deceleration: float = 0.8 ## character movement deceleation
@export_range(0,1,0.2) var aim_deceleration: float = 0.8 ## aim deceleration

@export_category("Attack")
@export var Gun: Marker2D

var previous_motion: Vector2 = Vector2.ZERO
var previous_aim_position: Vector2 = get_global_mouse_position()

## gets player input and transforms it to velocity
func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()

	_handle_movement(delta)
	_handle_aim()

	if(Input.is_action_pressed("attack")):
		_shoot()	

## Handles player movement
func _handle_movement(delta: float):
	var current_motion: Vector2 = velocity * delta
	current_motion = current_motion.lerp(previous_motion, movement_deceleration)
	
	move_and_collide(current_motion)
	
	previous_motion = current_motion

## handles player aim
func _handle_aim():
	var current_aim_position: Vector2 = get_global_mouse_position()
	current_aim_position = current_aim_position.lerp(previous_aim_position,aim_deceleration) 
	
	look_at(current_aim_position)
	
	previous_aim_position = current_aim_position

func _shoot():
	if(Gun != null):
		Gun.shoot(get_global_mouse_position())
	
func take_damage(damage):
	print(damage)