extends AudioStreamPlayer2D

@export var pain_sounds: Array[AudioStream]

func play_pain_sound():
	var selected_sound = pain_sounds.pick_random()
	stream = selected_sound
	play()