extends State

func enter():
	state_owner.get_animation_player().move()
	pass

func pyhsics_update(delta):
	state_owner.look_at(state_owner.get_player().global_position)
