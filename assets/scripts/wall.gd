extends StaticBody2D

@export var wall_size := Vector2.ZERO

func _ready():
	var collision = self.get_node("CollisionShape2D") as CollisionShape2D
	collision.position = wall_size * 0.5
	collision.shape = RectangleShape2D.new()
	collision.shape.size = wall_size
	var texture_rect = self.get_node("TextureRect") as TextureRect
	texture_rect.size = wall_size * (1/texture_rect.scale.x)

func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		destroy_wall.rpc()

@rpc("any_peer","call_local")
func destroy_wall():
	print("Destroying wall", self.name)
	queue_free()
