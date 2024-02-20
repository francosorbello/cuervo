extends Control

var started : bool = false
var current_time : float = 0
@onready var text_label = $RichTextLabel 

func start():
    started = true

func stop():
    started = false

func reset():
    current_time = 0

func _process(delta):
    if(started):
        current_time += delta
        text_label.text = "%.1f"%current_time
    