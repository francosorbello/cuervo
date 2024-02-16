extends Control

@export var line_label : RichTextLabel
@export var line_velocity : float = 1.5
@export var initial_timer : float = 3
@export_range(1,3) var max_rows : int = 3 

@export_category("Auto start")
@export var autostart : bool = false
@export var initial_dialogue : Dialogue

@export_category("Fade")
@export var fade_in_duration : float = 0.5
@export var fade_out_duration : float = 0.5
@export var hide_on_start : bool = true

var current_dialogue : Dialogue
var current_line : int = 0
var current_row : int = 0

func _ready():
	if(hide_on_start):
		modulate = Color(0,0,0,0)
		
	if(autostart):
		start_dialogue(initial_dialogue)

func start_dialogue(dialogue: Dialogue):
	if(dialogue == null):
		return
		
	await fade_in()
	await get_tree().create_timer(initial_timer).timeout

	current_dialogue = dialogue
	current_line = 0
	read_line(current_dialogue.lines[0])

func read_line(line : DialogueLine):
	var tween = get_tree().create_tween()
	
	if(line_label != null):

		if(current_row == max_rows or line.single_row):
			line_label.clear()
			current_row = 0
		else:
			current_row += 1
		
		line_label.visible_characters = line_label.get_parsed_text().length()
	   
		var previous_line = line_label.get_parsed_text()
		line_label.append_text(center_text(line.Line))
	   
		line_label.visible_ratio = get_visible_ratio(previous_line,line.Line)
		tween.tween_property(line_label,"visible_ratio",1,line_velocity)
		$TalkAudioPlayer.voice_line(line,line_velocity)
	   
		$LineTimer.start(line.duration)
	pass

func get_visible_ratio(prev_line, new_line) -> float:
	var total_characters = prev_line.length() + new_line.length()
	return float(prev_line.length()) / total_characters

func center_text(text : String) -> String:
	return "[center] %s [/center]" % text

func next_line():
	if(current_dialogue.lines[current_line].single_row):
		line_label.clear()

	current_line += 1
	if current_line < len(current_dialogue.lines):
		read_line(current_dialogue.lines[current_line])
	else:
		fade_out()

func _on_line_timer_timeout():
	next_line()

func fade_in():
	await _do_fade(1,fade_in_duration)

func fade_out():
	await _do_fade(0,fade_out_duration,0)

func _do_fade(value: float,time: float, override_transparency: float = 1):
	var tween = get_tree().create_tween()
	await tween.tween_property(self,"modulate",Color(value,value,value,override_transparency),time).finished
