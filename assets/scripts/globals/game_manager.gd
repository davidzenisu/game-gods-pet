extends Node

signal score_updated(scores: Dictionary)
signal vote_updated(votes: Dictionary)
signal pet_updated(player_id: int)
signal timer_updated(time_left_perc: float)
signal round_ended()
signal round_started()
signal vote_ended()
signal game_score_updated(game_score: Dictionary)

@export var round_length = 90.0 # seconds
func is_debug() -> bool:
	return false
var player_count = 4
var god_identifier = player_count

var main_menu : CanvasLayer
var lobby : CanvasLayer
var main : Main
var level: Node2D
var players: Array = []
var god_pet: int = -1
var scores: Dictionary = {}
var votes: Dictionary = {}
var game_score: Dictionary = {}
var vote_tracker: Dictionary = {}
var round_winners: Array = []
var game_timer: SceneTreeTimer
var game_running : bool = false

var player_colors: Dictionary = {
	0 : Color(1, 0, 0),
	1 : Color(0, 1, 0),
	2 : Color(0, 0, 1),
	3 : Color(1, 1, 0)
}

func _ready() -> void:
	_check_launch_args()
	setup_multiplayer_input(player_count)
	
func setup_multiplayer_input(playerCount:int):
	var actionList:Array[StringName]
	var actionEventList:Array[InputEvent]
	var currentAction:StringName
	var currentEvent:InputEvent
	actionList = InputMap.get_actions()

	var contollers = Input.get_connected_joypads()
	print("Connected controllers: ", contollers)
	var controller_index = 0
	
	for player in range(playerCount):
		var joypad_name = Input.get_joy_name(controller_index)
		print("Configuring controller: ", joypad_name)
		if (joypad_name=="Steam Deck Controller" && contollers.size() > playerCount):
			print("Skipping Steam Deck Controller")
			controller_index += 1
		for act in range(actionList.size()):
			if(actionList[act].begins_with("ui_")):
				continue
			currentAction = actionList[act]+str(player)
			InputMap.add_action(currentAction)
			actionEventList = InputMap.action_get_events(actionList[act])
			for event in range(actionEventList.size()):
				currentEvent = actionEventList[event].duplicate(true)
				currentEvent.set_device(controller_index)
				InputMap.action_add_event(currentAction,currentEvent)
		controller_index += 1

func create_main_menu() -> CanvasLayer:
	if is_instance_valid(main_menu):
		main_menu.queue_free()
		main_menu.get_parent().remove_child(main_menu)
	var mm : CanvasLayer = load("res://assets/scenes/ui/main_menu.tscn").instantiate()
	main_menu = mm
	return mm

func instantiate_level():
	game_running = true
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
	var pad_index = 0
	players.clear()
	for pad in joypads:
		print("Joypad ID: ", pad)
		print("Player index: ", pad_index)
		if pad >= player_count:
			print("Skipping joypad (exceeds max player count): ", pad)
			continue
		var character = preload("res://assets/scenes/player.tscn").instantiate()
		#TODO: Only set player id once
		character.player_id = pad_index
		var player_input = character.get_node("PlayerInput")
		player_input.player_id = pad_index
		character.name = "Player_" + str(pad_index)
		scores[pad_index] = 0
		votes[pad_index] = 0
		vote_tracker[pad_index] = false
		# position in each corner
		var screen_size = get_viewport().get_visible_rect().size
		print(Input.get_joy_name(pad_index))
		#if (Input.get_joy_name(pad_index) == "Steam Deck Controller"):
			#continue;
		match pad_index:
			0:
				character.position = Vector2(0, 0)
				character.modulate = player_colors[pad_index]
			1:
				character.position = Vector2(screen_size.x, 0)
				character.modulate = player_colors[pad_index]
			2:
				character.position = Vector2(0, screen_size.y)
				character.modulate = player_colors[pad_index]
			3:
				character.position = Vector2(screen_size.x, screen_size.y)
				character.modulate = player_colors[pad_index]
			_:
				character.position = Vector2(screen_size.x/2, screen_size.y/2)
				continue;
		print("Spawning player with joypad: ", pad)
		playerNode.add_child(character, true)
		pad_index += 1
		players.append(character)
	# update pet based on number of players
	god_pet = range(players.size()).pick_random()
	pet_updated.emit(god_pet)
	score_updated.emit(scores)
	vote_updated.emit(votes)

func instantiate_coin():
	if (level == null or game_running == false):
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

func instantiate_level_timer():
	if (level == null):
		return
	game_timer = get_tree().create_timer(round_length)
	var on_round_end = func ():
		round_over()
	game_timer.timeout.connect(on_round_end)
	# Start a process to update the timer UI
	get_tree().create_timer(1).timeout.connect(on_timer_update)

func on_timer_update():
	var time_left = game_timer.time_left
	var time_left_perc = time_left / round_length
	timer_updated.emit(time_left_perc)
	if time_left > 0:
		get_tree().create_timer(1).timeout.connect(on_timer_update)

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
	# only server updates scores!
	if not multiplayer.is_server():
		return
	print("Current scores: %s" % str(scores))
	print("Player %d scored %d points!" % [player_id, points])
	scores[player_id] += points
	print("Current scores: %s" % str(scores))
	score_updated.emit(scores)

func vote_cast(player_id: int, player_id_cast: int, points = 1) -> void:
	if not multiplayer.is_server() or vote_tracker[player_id_cast] or !votes.has(player_id):
		return
	print("New vote for player: %d" % player_id)
	votes[player_id] += points
	vote_tracker[player_id_cast] = true
	print("Current votes: %s" % str(votes))
	vote_updated.emit(votes)

func round_over() -> void:
	game_running = false
	if not multiplayer.is_server():
		return
	var player_nodes = get_tree().get_nodes_in_group("players")
	for player in player_nodes:
		player.queue_free()
	var coin_nodes = get_tree().get_nodes_in_group("coins")
	for coin in coin_nodes:
		coin.queue_free()
	var wall_nodes = get_tree().get_nodes_in_group("walls")
	for wall in wall_nodes:
		wall.queue_free()
	round_winners.clear()
	round_ended.emit()
	determine_winner_prevote()

func determine_winner_prevote():
	var pet_winning = true
	# if any player has equal or higher score
	for key in scores:
		if key == god_pet:
			continue
		# if score is higher or equal to pet: pet/god lost
		if scores[key] >= scores[god_pet]:
			pet_winning = false
			print("Pet lost")
		# if score is highest, player wins
		if scores[key] == scores.values().max() and scores[key] > 0:
			print("Adding winner", key)
			round_winners.append(key)
	if !pet_winning:
		add_game_scores()
		GameManager.vote_ended.emit()

func vote_over() -> void:
	# only transition if all votes have been fulfilled
	var not_voted = func (vote_cast):
		return !vote_cast
	if vote_tracker.values().any(not_voted):
		return
	determine_winner()
	GameManager.vote_ended.emit()

func determine_winner():
	#If pet has majority of votes (one more than others!)
	#var not_pet = func(score: int, scores: Dictionary):
		#
	var non_pet_votes = []
	for player_index in votes.keys():
		if player_index == god_pet:
			continue
		non_pet_votes.append(player_index)
	
	if votes[god_pet] > non_pet_votes.max():
		for player in range(players.size()):
			if player != god_pet:
				round_winners.append(player)
	else:
		round_winners.append(god_pet)
		# god = 4s
		round_winners.append(god_identifier)
	add_game_scores()

func add_game_scores():
	for winner in round_winners:
		if game_score.has(winner):
			game_score[winner] += 1
		else:
			game_score[winner] = 1
	print("Current game scores: ", game_score)

func restart_round() -> void:
	if game_running==true:
		return
	game_running = true
	instantiate_level_timer()
	instantiate_player()
	instantiate_coin()
	round_started.emit()
