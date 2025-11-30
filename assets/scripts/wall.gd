extends StaticBody2D

func _on_input_event(viewport, event, shape_idx):
	print("Wall clicked")
	print(event)
	if event is InputEventMouseButton and event.pressed:
		print("Wall clicked")
		queue_free()

func _on_mouse_entered():
	print("Mouse entered wall area")
