extends Area2D

signal hit

@export var velocity = Vector2.ZERO

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

func _process(delta):
	velocity = input.direction
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x > 80 or velocity.x < -80:
		$AnimatedSprite2D.animation = &"default"
		$AnimatedSprite2D.flip_v = false
		$Trail.rotation = 0
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y > 80 or velocity.y < -80:
		$AnimatedSprite2D.animation = &"default"
		rotation = PI if velocity.y > 0 else 0

func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false

func _on_player_entered_coin(_body: Node2D) -> void:
	print("player collided with object")
	if _body.is_in_group("coins"):
		GameManager.player_scored(player_id)
		_body.queue_free()
		hit.emit()
