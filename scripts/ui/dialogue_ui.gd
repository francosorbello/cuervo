extends Control

@export var line_label : RichTextLabel
@export var line_velocity : float = 0.5

@export_range(1,3) var max_rows : int = 3 

@export var autostart : bool = false
@export var initial_dialogue : Dialogue

var current_dialogue : Dialogue
var current_line : int = 0
var current_row : int = 0

func _ready():
    if(autostart):
        start_dialogue(initial_dialogue)

func start_dialogue(dialogue: Dialogue):
    if(dialogue == null):
        return

    current_dialogue = dialogue
    current_line = 0
    read_line(current_dialogue.lines[0])

func read_line(line : DialogueLine):
    var tween = get_tree().create_tween()
    
    if(line_label != null):

        if(current_row == max_rows or line.single_row):
            # line_label.text = ""
            line_label.clear()
            print("rows surpassed")
            current_row = 0
        else:
            current_row += 1
        
        line_label.visible_characters = line_label.get_parsed_text().length()
        var previous_line = line_label.get_parsed_text()
        line_label.append_text(center_text(line.Line))
        line_label.visible_ratio = get_visible_ratio(previous_line,line.Line)
        tween.tween_property(line_label,"visible_ratio",1,line_velocity)
        $LineTimer.start(line.duration)
    pass

func get_visible_ratio(prev_line, new_line) -> float:
    print("prev line length: %s"%prev_line.length())
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
    pass

func _on_line_timer_timeout():
    next_line()
