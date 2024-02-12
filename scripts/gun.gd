extends Marker2D

@export var Bullet: PackedScene
@export var time_between_shots: float = 0.2

var current_time_between_shots = 0.0
var can_shoot: bool = true

signal shot_taken

func shoot(direction: Vector2):
	if(can_shoot):
		var bullet_instance: Node = Bullet.instantiate()
		if(bullet_instance.has_method("set_direction")):
			var dir = global_position.direction_to(direction)
			get_tree().get_root().add_child(bullet_instance)
			bullet_instance.global_position = global_position
			bullet_instance.set_direction(dir)

			can_shoot = false
			current_time_between_shots = 0

			$AudioStreamPlayer2D.play()
			shot_taken.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!can_shoot):
		current_time_between_shots += delta
		if(current_time_between_shots > time_between_shots):
			can_shoot = true
	
	
