extends AudioStreamPlayer

@export var full_song : AudioStreamMP3
@export var battle_song : AudioStreamMP3

@export var stop_delay : float = 0.5
func play_full():
    bus="Master"
    stream = full_song
    play()

func play_battle(start_delay : float = 0.0):
    bus="Master"
    if (start_delay > 0):
        await get_tree().create_timer(start_delay).timeout
    stream = battle_song
    play()

func stop_music():
    bus = "PlayerDeath"
    await get_tree().create_timer(stop_delay).timeout
    stop()