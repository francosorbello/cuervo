extends State

@export var move_speed : float = 50
@export var dive_threshold : float = 350

func enter():
    print("start move")
    state_owner.get_animation_player().move()
    pass

func pyhsics_update(delta):
    var player_position : Vector2 = state_owner.get_player().global_position 
    
    state_owner.look_at(player_position)
    
    state_owner.velocity = state_owner.global_position.direction_to(player_position)
    state_owner.move_and_collide(state_owner.velocity * move_speed * delta)

    if(should_dive()):
        state_machine.transition_to("DiveState")

func should_dive() -> bool:
    var distance = state_owner.global_position.distance_to(state_owner.get_player().global_position)
    return distance > dive_threshold