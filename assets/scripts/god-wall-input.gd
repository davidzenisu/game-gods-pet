extends Node2D

@export var preview_color: Color = Color(0.8, 0.2, 0.2)
@export var min_wall_size: int = 10
@export var max_walls: int = 3
@export var max_length: int = 300
@export var max_height: int = 50

var drag_start := Vector2.ZERO
var preview_rect := ColorRect.new()
var preview_active := false
var wall_size := Vector2.ZERO


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
		create_wall.rpc(drag_start, event.position, wall_size)
		# reset wall size
		wall_size = Vector2.ZERO

func update_preview(pos: Vector2):
	# determine if max height or length is exceeded
	var delta = pos - drag_start
	# can be either axis
	if abs(delta.x) > abs(delta.y):
		if abs(delta.x) > max_length:
			delta.x = sign(delta.x) * max_length
		if abs(delta.y) > max_height:
			delta.y = sign(delta.y) * max_height
	else:
		if abs(delta.y) > max_length:
			delta.y = sign(delta.y) * max_length
		if abs(delta.x) > max_height:
			delta.x = sign(delta.x) * max_height

	pos = drag_start + delta
	var top_left = Vector2(
		min(drag_start.x, pos.x),
		min(drag_start.y, pos.y)
	)
	var size = (pos - drag_start).abs()
	wall_size = size

	preview_rect.position = top_left
	preview_rect.size = size

@rpc("any_peer","call_local")
func create_wall(start: Vector2, end: Vector2, size: Vector2) -> void:
	if (!multiplayer.is_server() or !GameManager.game_running):
		return

	print("Spawning wall with", start, end, size)
	if size.x < min_wall_size or size.y < min_wall_size:
		return

	# determin top left position
	var top_left_x = start.x
	var top_left_y = start.y
	if start.x > end.x:
		top_left_x = start.x - size.x
	if start.y > end.y:
		top_left_y = start.y - size.y

	var top_left = Vector2(
		top_left_x,
		top_left_y
	)

	var wall = preload("res://assets/scenes/wall.tscn").instantiate()
	wall.wall_size = size
	wall.position = top_left
	wall.name = "Wall_%d" % randi()
	
	var wall_node = get_node("Walls")
	if wall_node.get_child_count() >= max_walls:
		wall_node.get_child(0).queue_free()
	wall_node.add_child(wall)
