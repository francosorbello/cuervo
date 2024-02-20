extends Node2D

@export var splatter : PackedScene

func do_splatter(from : Node, target: Node):
    var _splatter = splatter.instantiate()
    get_tree().current_scene.add_child(_splatter)
    _splatter.do_splatter(from,target)
