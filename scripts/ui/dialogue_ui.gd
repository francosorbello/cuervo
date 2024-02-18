extends Control
## Displays a dialogue to the player.

@export var line_label : RichTextLabel ## The label that will show the dialogue.
@export var line_velocity : float = 1.5 ## Speed at which the line will be typed.
@export var initial_timer : float = 3 ## Initial timer before the dialogue starts.
@export_range(1,3) var max_rows : int = 3  ## Number of allowed rows.

@export_category("Auto start")
@export var autostart : bool = false ## If true, the dialogue will play on start
@export var initial_dialogue : Dialogue ## Dialogue to display when [param autostart] is true

@export_category("Fade")
@export var fade_in_duration : float = 0.5 ## duration of the fade in animation.
@export var fade_out_duration : float = 0.5 ## duration of the fade out animation.
@export var hide_on_start : bool = true ## If true, the UI will hide itself on start.

var current_dialogue : Dialogue
var current_line : int = 0
var current_row : int = 0

signal dialogue_finished ## signal emited when the dialogue has finished displaying.

func _ready():
	if(hide_on_start):
		modulate = Color(0,0,0,0)
		
	if(autostart):
		start_dialogue(initial_dialogue)

## Displays a dialogue.
## [br]
## [param dialogue] : The dialogue to show to the player.
func start_dialogue(dialogue: Dialogue):
	if(dialogue == null):
		return
		
	await fade_in()
	await get_tree().create_timer(initial_timer).timeout

	current_dialogue = dialogue
	current_line = 0
	read_line(current_dialogue.lines[0])

func start_random_dialogue(dialogue: Dialogue):
	if (dialogue == null):
		return
		
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var selected_index : int = rand.randi_range(0,len(dialogue.lines)-1)
	
	# create new dialogue and use normal system
	# not the best implementation but the quickest
	var new_dialogue = Dialogue.new()
	new_dialogue.lines.append(dialogue.lines[selected_index])

	start_dialogue(new_dialogue)
	pass

## Displays a dialogue line.
## [br]
## [param line] : the line to display.
func read_line(line : DialogueLine):
	var tween = get_tree().create_tween()
	
	if(line_label != null):
		# row management
		if(current_row == max_rows or line.single_row or line.reset_row):
			line_label.clear()
			current_row = 0
		else:
			current_row += 1
		
		# show only characters that are already visible
		line_label.visible_characters = line_label.get_parsed_text().length()
	   
		# add new dialogue line
		var previous_line = line_label.get_parsed_text()
		line_label.append_text(center_text(line.Line))
	   
		# type line animation
		line_label.visible_ratio = get_visible_ratio(previous_line,line.Line)
		tween.tween_property(line_label,"visible_ratio",1,line_velocity)
		$TalkAudioPlayer.voice_line(line,line_velocity)
	   
		$LineTimer.start(line.duration)
	pass

## Returns the ratio of visible characters in a label.
## [br]
## [param prev_line] : Previous text displayed in the label [br]
## [param new_line] : The new text to add.
func get_visible_ratio(prev_line, new_line) -> float:
	var total_characters = prev_line.length() + new_line.length()
	return float(prev_line.length()) / total_characters

## Centers a line by adding a center bbcode tag to a line.
## [br]
## [param text] : the text to center.
func center_text(text : String) -> String:
	return "[center] %s [/center]" % text

## Displays the next DialogueLine in a Dialogue.
func next_line():
	if(current_dialogue.lines[current_line].single_row):
		line_label.clear()

	current_line += 1
	if current_line < len(current_dialogue.lines):
		read_line(current_dialogue.lines[current_line])
	else:
		dialogue_finished.emit()
		fade_out()

# Displays a new line when line timer runs out.
func _on_line_timer_timeout():
	next_line()

## Fades in the UI.
func fade_in():
	await _do_fade(1,fade_in_duration)

## Fades out the UI.
func fade_out():
	await _do_fade(0,fade_out_duration,0)

## Fade animation.
## [br]
## [param value] : Value to fade to. Usually 0 or 1. [br]
## [param time] : duration of the animation [br]
## [param override_transparency] : optional paramenter, will override the transparency of the UI. Default=1.
func _do_fade(value: float,time: float, override_transparency: float = 1):
	var tween = get_tree().create_tween()
	await tween.tween_property(self,"modulate",Color(value,value,value,override_transparency),time).finished
