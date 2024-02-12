extends State

func enter():
    state_owner.get_animation_player().move()
    pass

func pyhsics_update(delta):
    state_owner.look_at(state_owner.get_player().global_position)
    state_owner.velocity = state_owner.global_position.direction_to(state_owner.get_player().global_position)
    state_owner.move_and_collide(state_owner.velocity*state_owner.speed*delta)