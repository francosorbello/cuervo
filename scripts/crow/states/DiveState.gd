extends State

@export var dive_speed : float = 300
@export var move_threshold: float = 40 # Enemy will transition to moving if their distance is lower than this threshold 

var last_player_position : Vector2

func enter():
    # store last player position, as the enemy will dive towards there
    last_player_position = state_owner.get_player().global_position

func pyhsics_update(delta):
    var target = $SurroundPositionComponent.get_random_circle_position(last_player_position)
    state_owner.look_at(target)

    state_owner.velocity = state_owner.global_position.direction_to(target)
    state_owner.move_and_collide(state_owner.velocity*dive_speed*delta)

    if(should_move()):
        state_machine.transition_to("MoveState")

func should_move() -> bool:
    var distance = state_owner.global_position.distance_to(last_player_position)
    return distance < move_threshold