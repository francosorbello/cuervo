extends StaticBody2D

var target : Node2D

func _ready():
	$AnimationPlayer.play("idle")
	

func setup(pos: Vector2, _target: Node2D):
	target = _target
	global_position = pos

func _process(_delta):
	if(target != null):
		look_at(target.global_position)
		pass
