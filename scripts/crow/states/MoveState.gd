extends State

@export var move_speed : float = 100
@export var dive_threshold : float = 150
@export var surround_radius: float = 40

var random_angle : float

func enter():
    state_owner.get_animation_player().move()

    var rng = RandomNumberGenerator.new()
    random_angle = rng.randf_range(-1,1)
    pass

func pyhsics_update(delta):
    # var player_position : Vector2 = state_owner.get_player().global_position 
    var move_to : Vector2 = get_circle_position()

    state_owner.look_at(state_owner.get_player().global_position)
    
    state_owner.velocity = state_owner.global_position.direction_to(move_to)
    state_owner.move_and_collide(state_owner.velocity * move_speed * delta)

    if(should_dive()):
        state_machine.transition_to("DiveState")

func should_dive() -> bool:
    var distance = state_owner.global_position.distance_to(state_owner.get_player().global_position)
    return distance > dive_threshold

func get_circle_position() -> Vector2:
    var kill_circle_center = state_owner.get_player().position
    var angle = random_angle * PI * 2

    var x = kill_circle_center.x + cos(angle) * surround_radius
    var y = kill_circle_center.y + sin(angle) * surround_radius

    return Vector2(x,y)
