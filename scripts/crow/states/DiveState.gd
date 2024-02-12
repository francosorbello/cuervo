extends State

@export var dive_speed : float = 300
@export var dive_threshold: float = 10

var last_player_position : Vector2

func enter():
    print("start dive")
    last_player_position = state_owner.get_player().global_position

func pyhsics_update(delta):
    state_owner.look_at(last_player_position)

    state_owner.velocity = state_owner.global_position.direction_to(last_player_position)
    state_owner.move_and_collide(state_owner.velocity*dive_speed*delta)

    if(should_move()):
        state_machine.transition_to("MoveState")

func should_move() -> bool:
    var distance = state_owner.global_position.distance_to(last_player_position)
    return distance < dive_threshold