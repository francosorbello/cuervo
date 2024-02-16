extends Control

@export var line_label : RichTextLabel
@export var line_velocity : float = 0.5
@export var initial_dialogue : Dialogue
@export var autostart : bool = false

var current_dialogue : Dialogue
var current_line : int = 0

func _ready():
    if(autostart):
        start_dialogue(initial_dialogue)

func start_dialogue(dialogue: Dialogue):
    if(dialogue == null):
        return

    current_dialogue = dialogue
    current_line = 0
    read_line(dialogue.lines[0])

func read_line(line : DialogueLine):
    var tween = get_tree().create_tween()
    if(line_label != null):
        line_label.visible_characters = line_label.text.length()
        line_label.text = center_text(line.Line)
        line_label.visible_ratio = 0
        tween.tween_property(line_label,"visible_ratio",1,line_velocity)
        $LineTimer.start(line.duration)
    pass

func center_text(text : String) -> String:
    return "[center] %s [/center]" % text

func next_line():
    current_line += 1
    if current_line < len(current_dialogue.lines):
        read_line(current_dialogue.lines[current_line])
    pass

func _on_line_timer_timeout():
    next_line()
