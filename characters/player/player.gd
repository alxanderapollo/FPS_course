extends CharacterBody3D
#refrence to the camera - equivlent to get camera node - onready means it happens when the scene starts
@onready var camera_3d = $Camera3D


@onready var character_mover = $CharacterMover
#horizontal and vertical mouse sensetivity
@export var mouse_sensitivity_h = 0.15
@export var mouse_sensitivity_v = 0.15

#gets called at run time 
func _ready():
#captures the mouse
#hmouse mode captured the mouse will be hidden and its posttion locked at the center of the windows manager
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 

#input function is called whenever any form of input is done on the mouse by the player
#we want the mouse movedment now
func _input(event):
#	if player moves the mouse, 
	if event is InputEventMouseMotion:
#		horizontal mouse movement since the previous frame - multipling by sensetivity increases the sensitivity on the mouse
#		relative is the movement delta of mouse since the previous frame
#		rotates the player left and right
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h
#	 	rotates he player up and down, 
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v
#		clamping makes so the player cant tile past straight of 90 degrees
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -90, 90)

func _process(delta):
	if Input.is_action_just_pressed("quit"): get_tree().quit()
	if Input.is_action_just_pressed("restart"): get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullscreen"):
		var win := get_window()
		if win.mode == Window.MODE_FULLSCREEN:
			win.mode = Window.MODE_WINDOWED
		else:
			win.mode = Window.MODE_FULLSCREEN
	
	#input durection for movement - only a 2d vector - good enough if it were only a top down 2 d game 
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	#here we convert the 2d vector into a 3D vector by adding horizontal movement
	#normalized prevents fast diagonal movement
	var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
#	update the players move direcitons with the function from character mover
	character_mover.set_move_dir(move_dir)
	
	if Input.is_action_just_pressed("jump"): 
		print('jump was pressed!')
		character_mover.jump()

	
