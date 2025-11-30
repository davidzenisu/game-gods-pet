extends Node2D

@export var wall_color: Color = Color(0.8, 0.2, 0.2)
@export var preview_color: Color = Color(0.8, 0.2, 0.2)
@export var min_wall_size: float = 8.0

var drag_start := Vector2.ZERO
var preview_rect := ColorRect.new()
var preview_active := false


func _ready():
	preview_rect.visible = false
	preview_rect.color = preview_color
	add_child(preview_rect)


func _input(event):
	# --- START DRAG (Touch OR Mouse Left Button) ---
	if (event is InputEventScreenTouch and event.pressed) \
		or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):

		drag_start = event.position
		preview_active = true

		preview_rect.position = drag_start
		preview_rect.size = Vector2.ZERO
		preview_rect.visible = true
	# --- UPDATE DRAG (Touch OR Mouse Motion) ---
	elif preview_active and (
		event is InputEventScreenDrag
		or (event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT))
	):
		update_preview(event.position)
	# --- END DRAG (Touch Release OR Mouse Left Button Release) ---
	elif preview_active and (
		(event is InputEventScreenTouch and not event.pressed)
		or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed)
	):
		preview_active = false
		preview_rect.visible = false
		create_wall(drag_start, event.position)

func update_preview(pos: Vector2):
	var top_left = Vector2(
		min(drag_start.x, pos.x),
		min(drag_start.y, pos.y)
	)
	var size = (pos - drag_start).abs()

	preview_rect.position = top_left
	preview_rect.size = size


func create_wall(start: Vector2, end: Vector2):
	var top_left = Vector2(
		min(start.x, end.x),
		min(start.y, end.y)
	)
	var size = (end - start).abs()

	if size.x < min_wall_size or size.y < min_wall_size:
		return

	var wall = preload("res://assets/scenes/wall.tscn").instantiate()
	#TODO: Refactor into wall script
	var rect = wall.get_node("ColorRect") as ColorRect
	rect.color = wall_color
	rect.size = size
	var collision = wall.get_node("CollisionShape2D") as CollisionShape2D
	collision.position = size * 0.5
	collision.shape = RectangleShape2D.new()
	collision.shape.size = size
	wall.position = top_left
	wall.name = "Wall_%d" % randi()
	
	var wall_node = get_node("Walls")
	wall_node.add_child(wall)
