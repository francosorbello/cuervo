extends Node2D

@export var initial_radius : float = 300
@export var crow_amount: int = 20
@export var CrowObstacle : PackedScene

func _ready():
    var player = get_tree().get_first_node_in_group("player")
    for crow_index in range(0,crow_amount):
        var obstacle = CrowObstacle.instantiate()
        add_child(obstacle)
        if(player != null):
            obstacle.setup(index_to_position(crow_index),player)
        else:
            obstacle.setup(index_to_position(crow_index),self)

func index_to_position(index : int):
    var angle_grad = (360 / float(crow_amount)) * index
    return Vector2(
        initial_radius * cos(deg_to_rad(angle_grad)) + global_position.x,
        initial_radius * sin(deg_to_rad(angle_grad)) + global_position.y
    )