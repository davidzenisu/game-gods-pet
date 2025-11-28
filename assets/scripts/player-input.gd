extends MultiplayerSynchronizer

@export var direction := Vector2()
@export var player_id: int:
	set(value):
		if is_inside_tree():
			printerr("player_id can only be set before instantiation.")
			return
		player_id = value

func _ready():
	# Only process for the local player
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("move_left%d" % player_id, "move_right%d" % player_id, "move_up%d" % player_id, "move_down%d" % player_id)
