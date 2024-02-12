class_name StateMachine extends Node

@export var initial_state : State

var current_state : State

func _ready():
    await owner.ready

    for child_state : State in get_children():
        child_state.setup(owner,self)

    current_state = initial_state
    current_state.enter()

func transition_to(target_state_name: String):
    if not has_node(target_state_name):
        return

    current_state.exit()
    current_state = get_node(target_state_name)
    current_state.enter()

func _process(delta):
    current_state.update(delta)   

func _physics_process(delta):
    current_state.pyhsics_update(delta)