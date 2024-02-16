extends AudioStreamPlayer

@export var min_pitch : int = 1
@export var max_pitch : int = 2

@onready var rand : RandomNumberGenerator = RandomNumberGenerator.new()

func voice_line(line : DialogueLine, line_speed : float):
    var audio_speed = stream.get_length()
    var line_word_count = line.Line.split(' ', false).size() #number of words in a line
    var timer_word_count = line_speed /audio_speed # number of words that can be said the span of line_speed

    var word_count = min(line_word_count,timer_word_count)
    rand.randomize()    
    for word in range(word_count):
        play()
        pitch_scale = rand.randf_range(min_pitch,max_pitch)
        await get_tree().create_timer(audio_speed).timeout
    pass