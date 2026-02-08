extends CharacterBody2D

signal eat

# @export var velocity = Vector2.ZERO

var player_sprites = [
	"dog_sprite",
	"cat_sprite",
	"fish_sprite",
	"hamster_sprite"
]

enum Sound {
	EAT
}

@onready var sounds = {
	Sound.EAT: $Sounds/CrunchSound,
}

var animation_sprite: AnimatedSprite2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport_rect().size
	set_player_sprite()
	var on_eat = func():
		play_sound(Sound.EAT)
	eat.connect(on_eat)

@export var player_id: int:
	set(value):
		# needs to allow to be set after instantiation!
		player_id = value
		set_player_sprite()

# not player id but authority id
@export var player_authority := 1 :
	set(id):
		player_authority = id
		$PlayerInput.set_multiplayer_authority(id)

@onready var input = $PlayerInput

func set_player_sprite():
	var scene_tree = get_tree()
	if scene_tree == null:
		return
	var sprites = scene_tree.get_nodes_in_group("sprite")
	for sprite in sprites:
		# only change sprite in subscene!
		if !self.is_ancestor_of(sprite):
			continue
		if sprite.get_groups().has(player_sprites[player_id % player_sprites.size()]):
			sprite.visible = true
			animation_sprite = sprite
		else:
			sprite.visible = false

func _physics_process(delta):
	velocity = input.direction
	
	if (
		GameManager.player_states.has(player_id) && 
		GameManager.player_states[player_id].shocked
		):
		velocity = Vector2.ZERO
	#if velocity.x > 0.5 or velocity.x < -0.5:
		#$AnimatedSprite2D.animation = &"default"
		#$AnimatedSprite2D.flip_v = false
		#$Trail.rotation = 0
		#$AnimatedSprite2D.flip_h = velocity.x < 0
	#elif velocity.y > 0.5 or velocity.y < -0.5:
		#$AnimatedSprite2D.animation = &"default"
		#rotation = PI if velocity.y > 0 else 0
	
	velocity = velocity.normalized() * speed
	
	if animation_sprite != null:
		if velocity.length() > 0:		
			animation_sprite.play()
		else:
			animation_sprite.stop()

	move_and_slide()

func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false

func play_sound(sound: Sound):
	if sounds.has(sound):
		sounds[sound].play()

func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		print("Animal was pressed!")
		shock_player.rpc(player_id)
		
@rpc("any_peer","call_local")
func shock_player(id: int):
	GameManager.shock_player(id)
