extends Camera2D

@export var noise_shake_speed: float = 30
@export var noise_shake_strength: float = 60.0
@export var shake_decay_rate: float = 5

@export_category("Zoom")
@export var f_zoom_out: float = 0.8
@export var f_zoom_in: float = 1.1

@export var zoom_in_duration: float = 0.8
@export var zoom_out_duration: float = 0.8
@export var focus_duration = 0.8

@onready var random_generator = RandomNumberGenerator.new()
@onready var noise_generator = FastNoiseLite.new()

var shake_strength : float = 0.0
var noise_position: float = 0.0

func _ready():
	random_generator.randomize()
	noise_generator.seed = random_generator.randi()
	zoom = Vector2(f_zoom_out,f_zoom_out)

func do_shake():
	shake_strength = noise_shake_strength

func _process(delta):
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)

	offset = get_noise_offset(delta)

func get_noise_offset(delta: float) -> Vector2:
	noise_position += delta * noise_shake_speed
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise_generator.get_noise_2d(1, noise_position) * shake_strength,
		noise_generator.get_noise_2d(100, noise_position) * shake_strength
	)

func zoom_in():
	_zoom_animation(f_zoom_in,zoom_in_duration)

func zoom_out():
	_zoom_animation(f_zoom_out,zoom_out_duration)
	pass

func _zoom_animation(value: float, time: float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom",Vector2(value,value),time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)

func _focus_animation(x : float, y: float, time: float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position",Vector2(x,y),time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)

func focus_top():
	_focus_animation(100,0, focus_duration)
	pass

func focus_center():
	_focus_animation(0,0,focus_duration)


func focus_on(point : Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position",point,focus_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
