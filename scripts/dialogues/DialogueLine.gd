extends Resource

class_name DialogueLine
## Object that represents a dialogue line.
##
## Lines are saved on disk as a Godot resource. 

@export var Line : String ## The dialogue line itself.
@export var duration : float = 5 ## Time the line is shown on screen.
@export var single_row : bool = false ## If true, the UI will display this line alone. 
@export var reset_row : bool = false ## If true, the UI will reset the row count, displaying this line as the first one.