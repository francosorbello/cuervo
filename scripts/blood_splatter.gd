extends CPUParticles2D

func do_splatter(from : Node, target: Node):
	# get_tree().current_scene.add_child(self)
	global_position = target.global_position
	print("splatter time")
	emitting = true
	rotation = from.global_position.angle_to_point(target.global_position)
	$Timer.timeout.connect(disable_particle)
	$Timer.start()

func disable_particle():
	print("disabling thing")
	emitting = false
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
