extends Node

func _ready():
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return
	print("Instantiating player")
	GameManager.instantiate_player()
