extends Node

func _ready():
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return
	print("Instantiating player")
	GameManager.instantiate_level_timer()
	GameManager.instantiate_player()
	GameManager.instantiate_coin()

func _on_spawn_coin():
	if not multiplayer.is_server():
		return
	GameManager.instantiate_coin()