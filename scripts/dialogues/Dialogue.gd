extends Resource
class_name Dialogue
## Resource for dialogues. Contains an array of lines.
##
## Each conversation consists in a list of lines that are shown to the player sequentially.
## The conversation is saved on disk as a Godot resource.

@export var lines : Array[DialogueLine] ## List of lines that form the conversation.