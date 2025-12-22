extends StaticBody2D

func _ready():
	var color_rect = self.get_node("ColorRect") as ColorRect
	var size = color_rect.size
	var collision = self.get_node("CollisionShape2D") as CollisionShape2D
	collision.position = size * 0.5
	collision.shape = RectangleShape2D.new()
	collision.shape.size = size

func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		destroy_wall.rpc()

@rpc("any_peer","call_local")
func destroy_wall():
	print("Destroying wall", self.name)
	queue_free()