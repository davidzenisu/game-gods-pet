extends CharacterBody2D

signal hit

# @export var velocity = Vector2.ZERO

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size

@export var player_id: int:
	set(value):
		if is_inside_tree():
			printerr("player_id can only be set before instantiation.")
			return
		player_id = value

# not player id but authority id
@export var player_authority := 1 :
	set(id):
		player_authority = id
		$PlayerInput.set_multiplayer_authority(id)

@onready var input = $PlayerInput

func _physics_process(delta):
	velocity = input.direction

	if velocity.x > 0.5 or velocity.x < -0.5:
		$AnimatedSprite2D.animation = &"default"
		$AnimatedSprite2D.flip_v = false
		$Trail.rotation = 0
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y > 0.5 or velocity.y < -0.5:
		$AnimatedSprite2D.animation = &"default"
		rotation = PI if velocity.y > 0 else 0

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	move_and_slide()

func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false
