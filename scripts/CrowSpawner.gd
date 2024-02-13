extends Node2D

@export var initial_amount: int = 3
@export var Crow : PackedScene

@onready var rand : RandomNumberGenerator = RandomNumberGenerator.new()
var current_amount : int
var killed_crows : int = 0

signal wave_finished

func _ready():
    current_amount = initial_amount

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
    return current_amount + 2