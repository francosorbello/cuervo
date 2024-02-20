extends Control

@export var auto_hide : bool = true
@export var random_dialogues : Dialogue

@export_category("Animations")
@export var transition_in_speed : float = 1.0
@export var transition_out_speed : float = 1.0

@onready var rand : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
    # display_random_dialogue()
    # hide on start
    if(auto_hide):
        modulate = Color(1,1,1,0)

func toggle(value : bool):
    # visible = value
    if(value):
        return transition_in()
    else:
        return transition_out()

func transition_in():
    return _transition_anim(1,transition_in_speed)

func transition_out():
    return _transition_anim(0,transition_out_speed)

func _transition_anim(transparency_value : float, time : float):
    var tween = get_tree().create_tween()
    return tween.tween_property(self,"modulate",Color(1,1,1,transparency_value),time).finished

func display_random_dialogue():
    if (random_dialogues == null or len(random_dialogues.lines) == 0):
        return
        
    rand.randomize()
    var selected_index : int = rand.randi_range(0,len(random_dialogues.lines) - 1)
    var text = random_dialogues.lines[selected_index].Line
    $VBoxContainer/RandomLineLabel.text = "[center] %s [/center]" % text
    pass

func _on_button_pressed():
    toggle(false)
    pass

func win_screen():
    $VBoxContainer/RandomLineLabel.text = "[center] %s [/center]" % "A new cycle awaits."
    $VBoxContainer/AspectRatioContainer.visible = false
    $VBoxContainer/WinAspectRatio.visible=true
    toggle(true)

func _on_win_button_pressed():
    get_tree().reload_current_scene()
