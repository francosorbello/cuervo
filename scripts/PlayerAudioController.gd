extends AudioStreamPlayer2D
## Node to control audio stuff for players.

@export var pain_sounds: Array[AudioStream] ## List of sounds the player makes when its hurt

## Plays a random pain sound from [param pain_sounds].
func play_pain_sound():
	var selected_sound = pain_sounds.pick_random()
	stream = selected_sound
	play()

func play_death_sound():
	bus = "PlayerDeath"
	play_pain_sound()