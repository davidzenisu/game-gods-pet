extends Label

@export var player_id := 0

func _ready():
	if multiplayer.is_server():
		GameManager.vote_updated.connect(update_votes)

func update_votes(votes: Dictionary):
	if votes.has(player_id):
		self.text = str(votes[player_id])