extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animation_player = $AnimationPlayer
	animation_player.play("FadeIn")
	var destroy = func():
		self.queue_free()
	animation_player.connect("animation_finished", destroy)
