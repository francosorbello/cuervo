extends Camera2D

@export var noise_shake_speed: float = 30
@export var noise_shake_strength: float = 60.0
@export var shake_decay_rate: float = 5

@onready var random_generator = RandomNumberGenerator.new()
@onready var noise_generator = FastNoiseLite.new()

var shake_strength : float = 0.0
var noise_position: float = 0.0

func _ready():
	random_generator.randomize()
	noise_generator.seed = random_generator.randi()

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
