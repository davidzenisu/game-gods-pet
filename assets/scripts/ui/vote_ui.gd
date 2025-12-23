extends Node


func _ready():
    if multiplayer.is_server():
        GameManager.round_ended.connect(_on_round_ended)

func _on_round_ended():
    self.visible = true