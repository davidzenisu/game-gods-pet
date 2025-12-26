extends Node

func _ready():
	if multiplayer.is_server():
		GameManager.round_ended.connect(_on_round_ended)
		GameManager.round_started.connect(_on_round_started)

func _on_round_ended():
	self.visible = true

func _on_round_started():
	self.visible = false

func _process(delta):
	if !self.visible or !multiplayer.is_server():
		return
	if Input.is_action_just_pressed("button_square0"):
		GameManager.vote_cast(0,0)
	if Input.is_action_just_pressed("button_square1"):
		GameManager.vote_cast(0,1)
	if Input.is_action_just_pressed("button_square2"):
		GameManager.vote_cast(0,2)
	if Input.is_action_just_pressed("button_square3"):
		GameManager.vote_cast(0,3)
	if Input.is_action_just_pressed("button_triangle0"):
		GameManager.vote_cast(1,0)
	if Input.is_action_just_pressed("button_triangle1"):
		GameManager.vote_cast(1,1)
	if Input.is_action_just_pressed("button_triangle2"):
		GameManager.vote_cast(1,2)
	if Input.is_action_just_pressed("button_triangle3"):
		GameManager.vote_cast(1,3)
	if Input.is_action_just_pressed("button_cross0"):
		GameManager.vote_cast(2,0)
	if Input.is_action_just_pressed("button_cross1"):
		GameManager.vote_cast(2,1)
	if Input.is_action_just_pressed("button_cross2"):
		GameManager.vote_cast(2,2)
	if Input.is_action_just_pressed("button_cross3"):
		GameManager.vote_cast(2,3)
	if Input.is_action_just_pressed("button_circle0"):
		GameManager.vote_cast(3,0)
	if Input.is_action_just_pressed("button_circle1"):
		GameManager.vote_cast(3,1)
	if Input.is_action_just_pressed("button_circle2"):
		GameManager.vote_cast(3,2)
	if Input.is_action_just_pressed("button_circle3"):
		GameManager.vote_cast(3,3)
	#restart game on start button
	if Input.is_action_just_pressed("button_start0"):
		GameManager.restart_round()
	if Input.is_action_just_pressed("button_start1"):
		GameManager.restart_round()
	if Input.is_action_just_pressed("button_start2"):
		GameManager.restart_round()
	if Input.is_action_just_pressed("button_start3"):
		GameManager.restart_round()
