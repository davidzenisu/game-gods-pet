extends Node

func _on_body_entered(_body: Node2D) -> void:
	print("coin collided with object")
	if _body.is_in_group("players"):
		GameManager.player_scored(_body.player_id)
		_body.eat.emit()
		queue_free()
