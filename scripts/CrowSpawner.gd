extends Node2D

@export var initial_amount: int = 3
@export var max_amount: int = 5
@export var Crow : PackedScene
@export var max_point_timer : float = 30

@onready var rand : RandomNumberGenerator = RandomNumberGenerator.new()
var current_amount : int
var killed_crows : int = 0
var max_point_reached : bool = false
var current_time : float = 0

signal wave_finished

func _ready():
    current_amount = get_spawn_amount()

func spawn_crows(spawn_points : Array):
    for i in range(0,current_amount):
        rand.randomize()
        var chosen_obstacle : int = rand.randi_range(0,len(spawn_points) - 1)
        
        var crow = Crow.instantiate()
        add_child(crow)

        crow.death.connect(on_crow_death)
        crow.global_position = spawn_points[chosen_obstacle]
        crow.do_dive()
        
        pass
    pass

func on_crow_death():
    killed_crows += 1
    if((current_amount - killed_crows) <= 0):
        killed_crows = 0
        current_amount = get_spawn_amount()
        wave_finished.emit()
    pass

func get_spawn_amount() -> int:
    var sum_amount : int = 0
    if(not max_point_reached):
        sum_amount = floori(lerp(initial_amount,max_amount,current_time/max_point_timer))
    else:
        sum_amount = floori(lerp(max_amount,initial_amount,current_time/max_point_timer))
    print(sum_amount)
    return sum_amount

func _on_max_point_timer_timeout():
    max_point_reached = true
    current_time = 0

func _process(delta):
    current_time += delta

func start_timer():
    current_time = 0
    $MaxPointTimer.start(max_point_timer)