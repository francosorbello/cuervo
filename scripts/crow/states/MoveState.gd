extends State

@export var move_speed : float = 100 
@export var dive_threshold : float = 150 ## Enemy will transition to diving if this distance is surpassed


func enter():
	state_owner.get_animation_player().move()

# Enemy moves towards the player, trying to surround them
func pyhsics_update(delta):
	var move_to : Vector2 = $SurroundPositionComponent.get_random_circle_position(state_owner.get_player().global_position)
	# var player_position : Vector2 = state_owner.get_player().global_position 

	state_owner.look_at(state_owner.get_player().global_position)
	
	state_owner.velocity = state_owner.global_position.direction_to(move_to)
	state_owner.move_and_collide(state_owner.velocity * move_speed * delta)

	if(should_dive()):
		state_machine.transition_to("DiveState")

## Indicates if the enemy should start diving.
func should_dive() -> bool:
	var distance = state_owner.global_position.distance_to(state_owner.get_player().global_position)
	return distance > dive_threshold
