extends Node

func _ready():
    if multiplayer.is_server():
        print("Only display score for gods. Disabling UI.")
        self.visible = false



func update_score(label: int, new_score: int):
    var score_label = $Scores.get_node("PlayerScore%d" % label) as Label
    score_label.text = new_score