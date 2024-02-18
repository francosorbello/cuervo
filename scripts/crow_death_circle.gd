extends Node2D
## Object that spawns a circle of crows that shrinks, Fornite style.

@export var initial_radius : float = 300 
@export var obstacle_amount: int = 20 ## Number of crow obstacles that spawn
@export var reduce_rate: float = 5 ## Rate the circle shrinks to
@export var autostart : bool = false
@export var obstacle_anim_timer : float = 0.05 ## Time between spawning each crow

@export var CrowObstacle : PackedScene

var obstacles : Array
var current_radius: float = 0

@onready var rand : RandomNumberGenerator = RandomNumberGenerator.new() 

## Sets start position of the circle. 
## [br]
## [param pos] : new position.
func set_start_position(pos : Vector2):
    global_position = pos

func _ready():
    if autostart:
        start_circle()

## Spawns the circle with an animation.
func start_circle():
    var player = get_tree().get_first_node_in_group("player")
    current_radius = initial_radius 
    for crow_index in range(0,obstacle_amount):
        $SpawnAudioPlayer.play()
        await get_tree().create_timer(obstacle_anim_timer).timeout

        var obstacle = CrowObstacle.instantiate()
        add_child(obstacle)
        
        obstacle.setup(index_to_position(crow_index,current_radius),player)
        obstacles.append(obstacle)
    
    $CrowSpawner.wave_finished.connect(on_wave_finished)
    spawn_crows()
    $CrowSpawner.start_timer()

## Transforms an index to a position in the borders of a cirlce.
## [br]
## [param index] : index to transform [br]
## [param radius] : radius of the circle.
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

# called when the player kills all enemies.
func on_wave_finished():
    $WaveTimer.start()
    pass

# called when the timer for the next wave finishes.
func _on_wave_timer_timeout():
    spawn_crows()
    pass

## Spawns enemies from the borders of the circle.
func spawn_crows():
    var obstacle_positions : Array = []

    for obstacle in obstacles:
        obstacle_positions.append(obstacle.global_position)

    $CrowSpawner.spawn_crows(obstacle_positions)

