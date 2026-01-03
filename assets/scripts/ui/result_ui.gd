extends Node

var screen_timer: SceneTreeTimer
var can_progress: bool = false

func _ready():
	if multiplayer.is_server():
		GameManager.vote_ended.connect(_on_vote_ended)
		GameManager.round_started.connect(_on_round_started)

func _on_vote_ended():
	hide_winner()
	self.visible = true
	screen_timer = get_tree().create_timer(5)
	screen_timer.timeout.connect(_on_timer_elapsed)
	for key in GameManager.scores:
		update_score(key, GameManager.scores[key])
	for key in GameManager.game_score:
		update_game_score(key, GameManager.game_score[key])
	update_pet_sprite()
	update_winner_sprite()

func _on_round_started():
	self.visible = false
	can_progress = false

func _on_timer_elapsed():
	show_winner()
	can_progress = true

func _process(delta):
	if !self.visible or !multiplayer.is_server() or !can_progress:
		return
	#restart game on start button
	if Input.is_action_just_pressed("button_start0"):
		GameManager.restart_round()
	if Input.is_action_just_pressed("button_start1"):
		GameManager.restart_round()
	if Input.is_action_just_pressed("button_start2"):
		GameManager.restart_round()
	if Input.is_action_just_pressed("button_start3"):
		GameManager.restart_round()

func hide_winner():
	var winner_screen = get_tree().get_first_node_in_group("winner_screen")
	if winner_screen != null:
		winner_screen.visible = false
	var winner_rows = get_tree().get_nodes_in_group("winner_row")
	for winner_row in winner_rows:
		winner_row.visible = false

func show_winner():
	var winner_screen = get_tree().get_first_node_in_group("winner_screen")
	if winner_screen != null:
		winner_screen.visible = true
	var winner_rows = get_tree().get_nodes_in_group("winner_row")
	for winner_row in winner_rows:
		if GameManager.round_winners.has(GameManager.god_identifier) and winner_row.name == "WinnersGod":
			winner_row.visible = true
		elif !GameManager.round_winners.has(GameManager.god_identifier) and winner_row.name == "WinnersAnimals":
			winner_row.visible = true

func update_score(label: int, new_score: int):
	var score_label_search = get_tree().get_nodes_in_group("score")
	if score_label_search.size() == 0:
		return
	for score_label in score_label_search:
		if score_label.name == "PlayerScore%d" % label:
			score_label.text = str(new_score)

func update_game_score(label, new_score: int):
	var score_label_search = get_tree().get_nodes_in_group("round_score")
	if score_label_search.size() == 0:
		return
	for score_label in score_label_search:
		if score_label.name == "GodScore" and label == GameManager.god_identifier:
			score_label.text = str(new_score)
		elif score_label.name == "PlayerScore%d" % label:
			score_label.text = str(new_score)

func update_pet_sprite():
	var pet_sprites = get_tree().get_nodes_in_group("pet_sprite")
	for pet_sprite in pet_sprites:
		pet_sprite.modulate = GameManager.player_colors[GameManager.god_pet]

func update_winner_sprite():
	var animal_sprites = get_tree().get_nodes_in_group("player_sprite")
	for animal_sprite in animal_sprites:
		animal_sprite.visible = false
	if GameManager.round_winners.has(GameManager.god_identifier):
		return
	var sprite_index = 0
	for winner in GameManager.round_winners:
		if sprite_index >= animal_sprites.size():
			continue
		animal_sprites[sprite_index].visible = true
		animal_sprites[sprite_index].modulate = GameManager.player_colors[winner]
		sprite_index += 1
