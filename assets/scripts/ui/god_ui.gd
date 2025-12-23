extends Node

func _ready():
	if multiplayer.is_server() and  !OS.is_debug_build():
		print("Only display score for gods. Disabling UI.")
		self.visible = false
	GameManager.score_updated.connect(update_scores)
	GameManager.timer_updated.connect(update_timer)
	GameManager.round_ended.connect(_on_round_ended)

func update_scores(scores: Dictionary):
	print("Updating scores")
	update_scores_rc.rpc(scores)

@rpc("any_peer","call_local")
func update_scores_rc(scores: Dictionary):
	for key in scores.keys():
		update_score(key, scores[key])

func update_score(label: int, new_score: int):
	var score_label_search = get_tree().get_nodes_in_group("Score")
	if score_label_search.size() == 0:
		return
	for score_label in score_label_search:
		if score_label.name == "PlayerScore%d" % label:
			score_label.text = str(new_score)

func update_timer(time_left_perc: float):
	update_timer_rc.rpc(time_left_perc)

@rpc("any_peer","call_local")
func update_timer_rc(time_left_perc: float):
	update_cooldown_visual(time_left_perc)

func update_cooldown_visual(new_value: float):
	var timer_progress_search = get_tree().get_nodes_in_group("RoundTimer")
	if timer_progress_search.size() == 0:
		return
	var timer_progress = timer_progress_search[0] as ProgressBar
	var tween := create_tween()
	tween.tween_property(
		timer_progress,
		"value",
		new_value,
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_round_ended():
	hide_ui_rc.rpc()

@rpc("any_peer","call_local")
func hide_ui_rc():
	self.visible = false
