extends Node

var main_menu : CanvasLayer
var lobby : CanvasLayer
var main : Main
var level: Node2D
var players: Array = []
var scores: Dictionary = {}

var debug : bool = false

func _ready() -> void:
	_check_launch_args()
	setup_multiplayer_input(4)

func setup_multiplayer_input(playerCount:int):
	var actionList:Array[StringName]
	var actionEventList:Array[InputEvent]
	var currentAction:StringName
	var currentEvent:InputEvent
	actionList = InputMap.get_actions()

	var contollers = Input.get_connected_joypads()
	print("Connected controllers: ", contollers)

	for player in range(playerCount):
		for act in range(actionList.size()):
			if(actionList[act].begins_with("ui_")):
				continue
			currentAction = actionList[act]+str(player)
			InputMap.add_action(currentAction)
			actionEventList = InputMap.action_get_events(actionList[act])
			for event in range(actionEventList.size()):
				currentEvent = actionEventList[event].duplicate(true)
				currentEvent.set_device(player)
				InputMap.action_add_event(currentAction,currentEvent)
				print("Added action: ", currentAction, " with event: ", currentEvent)

func create_main_menu() -> CanvasLayer:
	if is_instance_valid(main_menu):
		main_menu.queue_free()
		main_menu.get_parent().remove_child(main_menu)
	var mm : CanvasLayer = load("res://assets/scenes/ui/main_menu.tscn").instantiate()
	main_menu = mm
	return mm

func instantiate_level():
	var level_parent = get_tree().get_root().get_node("/root/Main/Level")
	print("Spawning level")
	if multiplayer.is_server():
		level_parent.add_child(create_level(), true)
	else:
		print("Error, not server!")

func instantiate_player():
	if (level == null):
		return
	var joypads = Input.get_connected_joypads()
	print("Instantiating player for joypads: ", joypads.size())
	var playerNode = level.get_node("Players")
	print("Player node: ", playerNode)
	for pad in joypads:
		print("Joypad ID: ", pad)
		var character = preload("res://assets/scenes/player.tscn").instantiate()
		players.append(character)
		#TODO: Only set player id once
		character.player_id = pad
		var player_input = character.get_node("PlayerInput")
		player_input.player_id = pad
		character.name = "Player_" + str(pad)
		scores[pad] = 0
		# position in each corner
		var screen_size = get_viewport().get_visible_rect().size
		match pad:
			0:
				character.position = Vector2(0, 0)
				character.modulate = Color(1, 0, 0) # Red
			1:
				character.position = Vector2(screen_size.x, 0)
				character.modulate = Color(0, 1, 0) # Green
			2:
				character.position = Vector2(0, screen_size.y)
				character.modulate = Color(0, 0, 1) # Blue
			3:
				character.position = Vector2(screen_size.x, screen_size.y)
				character.modulate = Color(1, 1, 0) # Yellow
			_:
				character.position = Vector2(screen_size.x/2, screen_size.y/2)
		print("Spawning player with joypad: ", pad)
		playerNode.add_child(character, true)

func instantiate_coin():
	if (level == null):
		return
	# Create a new instance of the coin scene.
	var coin =  load("res://assets/scenes/coin.tscn").instantiate()
	coin.name = "Coin_%d" % randi()
	# ensure the coin is not overlapping any players
	var overlapping = true
	var timeout = 0
	var max_timeout = 100
	var random_position = Vector2.ZERO

	while overlapping and timeout < max_timeout:
		random_position = Vector2(
			randf() * get_viewport().get_visible_rect().size.x,
			randf() * get_viewport().get_visible_rect().size.y
		)
		#TODO: Check for overlapping objects
		overlapping = false
		timeout += 1
	
	coin.position = random_position
	# for player in players_node.get_children():
	# 	if coin.get_global_rect().intersects(player.get_global_rect()):
	# 		coin.position += Vector2(50, 50) # move the coin away if overlapping
	# # Add the coin to the Coins node in the level.
	level.get_node("Coins").add_child(coin)

func create_level() -> Node2D:
	if is_instance_valid(main_menu):
		main_menu.queue_free()
		main_menu.get_parent().remove_child(main_menu)
	print("Creating level")
	var l : Node2D = preload("res://assets/scenes/level.tscn").instantiate()
	level = l
	return l

func create_lobby() -> CanvasLayer:
	var lob : CanvasLayer = load("res://assets/scenes/ui/lobby.tscn").instantiate()
	lobby = lob
	return lob

func _check_launch_args() -> void:
	var args = OS.get_cmdline_args()
	if "--no-sound" in args:
		var master_bus_index = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(master_bus_index, true)
	if "--host" in args:
		await get_tree().create_timer(0.5).timeout
		NetworkManager._on_host_lan()
	if "--join" in args:
		await get_tree().create_timer(1.5).timeout
		NetworkManager._on_join_lan()

func player_scored(player_id: int, points = 1) -> void:
	if not multiplayer.is_server():
		return
	print("Current scores: %s" % str(scores))
	print("Player %d scored %d points!" % [player_id, points])
	scores[player_id] += points
	print("Current scores: %s" % str(scores))
