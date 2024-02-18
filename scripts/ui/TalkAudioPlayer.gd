extends AudioStreamPlayer
## Sound effect for voice lines.
##
## Some caveats:
## - The node will take into account how many words a line has, trying to match a sound to a word.
## - The number of sounds is capped by the time it takes to say a line, no matter the amount of words.
## - A random pitch between [param min_pitch] and [param max_pitch] will be applied to the sound.

@export var min_pitch : int = 1
@export var max_pitch : int = 2

@onready var rand : RandomNumberGenerator = RandomNumberGenerator.new()

## Adds a voice effect to a dialogue line.
## [br]
## [param line] : The line to voice. [br]
## [param line_speed] : the time it takes to say the line
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