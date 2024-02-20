extends Node2D
## Spawns crows from a set of positions.
##
## Currently, the number of enemies spawned is decided using a triangled shape function (something like /\) [br]
## This function goes from [param initial_amount] to [param max_amount] and then goes back to [initial_amount] [br]
## The idea is that as the circle closes, it makes more sense to spawn less enemies rather than for that number to keep getting bigger. 

@export var initial_amount: int = 3
@export var max_amount: int = 5
@export var Crow : PackedScene
@export var max_point_timer : float = 30 ## Time in seconds at which the triangled shape funtion will start to go back to [param initial_amount]

@onready var rand : RandomNumberGenerator = RandomNumberGenerator.new()
var current_amount : int
var killed_crows : int = 0
var max_point_reached : bool = false
var current_time : float = 0

signal wave_finished ## signal emited when the player kills all enemies.

func _ready():
	current_amount = get_spawn_amount()

## Spawns a wave of crows by picking random spawn points from a list.
## [br]
## [param spawn_points] : list of points a crow can spawn from.
func spawn_crows(spawn_points : Array):
	if (len(spawn_points) == 0):
		return

	for i in range(0,current_amount):
		rand.randomize()
		var chosen_obstacle : int = rand.randi_range(0,len(spawn_points) - 1)
		
		var crow = Crow.instantiate()
		add_child(crow)
		crow.add_to_group("enemy")
		crow.death.connect(on_crow_death)
		crow.global_position = spawn_points[chosen_obstacle]
		crow.do_dive()
		
		pass
	pass

# called when the player kills a crow
func on_crow_death():
	killed_crows += 1
	if((current_amount - killed_crows) <= 0):
		killed_crows = 0
		current_amount = get_spawn_amount()
		wave_finished.emit()
	pass

## Returns the number of enemies to spawn, based on a triangle shaped function.
func get_spawn_amount() -> int:
	var sum_amount : int = 0
	if(not max_point_reached):
		sum_amount = floori(lerp(initial_amount,max_amount,current_time/max_point_timer))
	else:
		sum_amount = floori(lerp(max_amount,initial_amount,current_time/max_point_timer))
	return sum_amount

func _on_max_point_timer_timeout():
	max_point_reached = true
	current_time = 0

func _process(delta):
	current_time += delta

## Starts the timer to indicate when the triangle shaped function should change.
func start_timer():
	current_time = 0
	$MaxPointTimer.start(max_point_timer)

## Delete all active crows and reset node
func reset():
	max_point_reached = false
	for crow in get_tree().get_nodes_in_group("enemy"):
		crow.queue_free()

func kill_all():
	for crow in get_tree().get_nodes_in_group("enemy"):
		crow.do_die()
