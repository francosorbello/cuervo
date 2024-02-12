extends State

func enter():
	print("start idle state")
	state_owner.get_animation_player().move()
	pass

func _physics_process(delta):
	state_owner.look_at(state_owner.get_player().global_position)
