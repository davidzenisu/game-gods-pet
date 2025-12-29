extends Label

func _ready():
	if multiplayer.is_server():
		GameManager.vote_updated.connect(update_votes)

func update_votes(votes: Dictionary):
	var sum_votes = func (accum, number):
		return accum + number
	self.text = str(GameManager.players.size() - votes.values().reduce(sum_votes, 0))
	
