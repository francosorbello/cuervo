extends StaticBody2D

var target : Node2D
@onready var rand = RandomNumberGenerator.new()

var debug_color : Color

func _ready():
    rand.randomize()
    debug_color = Color(rand.randf(),rand.randf(),rand.randf())
    $AnimationPlayer.play("idle")
    

func setup(pos: Vector2, _target: Node2D = null):
    target = _target
    global_position = pos
    # position = pos
    # print(global_position.direction_to(target.position))

func set_pos(pos: Vector2):
    global_position = pos

func _physics_process(_delta):
    if(target != null):
        # rotation = global_position.direction_to(target.position).angle()
        look_at(target.global_position)