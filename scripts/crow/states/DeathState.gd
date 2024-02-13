extends State

@export var death_sound : AudioStreamMP3
@export var audio_player: AudioStreamPlayer2D

func can_exit():
	return false

func enter():
	audio_player.stream = death_sound
	audio_player.play()
	state_owner.get_animation_player().die()
