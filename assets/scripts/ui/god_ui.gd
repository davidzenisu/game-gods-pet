extends Node

func _ready():
	if multiplayer.is_server():
		print("Only display score for gods. Disabling UI.")
		self.visible = false
	GameManager.score_updated.connect(update_scores)

func update_scores(scores: Dictionary):
	print("Updating scores")
	update_scores_rc.rpc(scores)

@rpc("any_peer","call_local")
func update_scores_rc(scores: Dictionary):
	for key in scores.keys():
		update_score(key, scores[key])

func update_score(label: int, new_score: int):
	var score_label = $GodUI/Scores.get_node("PlayerScore%d" % label) as Label
	if score_label == null:
		return
	score_label.text = str(new_score)
