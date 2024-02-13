extends Node2D

@export var initial_radius : float = 300
@export var obstacle_amount: int = 20
@export var reduce_rate: float = 5

@export var CrowObstacle : PackedScene

var obstacles : Array
var current_radius: float = 0

@onready var rand : RandomNumberGenerator = RandomNumberGenerator.new() 

func _ready():
    var player = get_tree().get_first_node_in_group("player")
    current_radius = initial_radius 
    for crow_index in range(0,obstacle_amount):
        var obstacle = CrowObstacle.instantiate()
        add_child(obstacle)

        obstacle.setup(index_to_position(crow_index,current_radius),player)
        obstacles.append(obstacle)
    
    $CrowSpawner.wave_finished.connect(on_wave_finished)
    spawn_crows()

func index_to_position(index : int, radius: float) -> Vector2:
    var angle_grad = (360 / float(obstacle_amount)) * index
    return Vector2(
        radius * cos(deg_to_rad(angle_grad)) + global_position.x,
        radius * sin(deg_to_rad(angle_grad)) + global_position.y
    )

func _physics_process(delta: float):
    if(current_radius <= 0.0):
        return
        
    current_radius -= reduce_rate * delta
    var i : int = 0
    for crow in obstacles:
        crow.set_pos(index_to_position(i,current_radius))
        i += 1
        pass

func on_wave_finished():
    $WaveTimer.start()
    pass

func _on_wave_timer_timeout():
    spawn_crows()
    pass

func spawn_crows():
    var obstacle_positions : Array = []

    for obstacle in obstacles:
        obstacle_positions.append(obstacle.global_position)

    $CrowSpawner.spawn_crows(obstacle_positions)