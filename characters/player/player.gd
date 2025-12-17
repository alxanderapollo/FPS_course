extends CharacterBody3D
#refrence to the camera - equivlent to get camera node - onready means it happens when the scene starts
@onready var camera_3d = $Camera3D
@onready var health_manager = $HealthManager
@onready var weapon_manager = $"Camera3D/Weapon Manager"
@onready var character_mover = $CharacterMover
#horizontal and vertical mouse sensetivity
@export var mouse_sensitivity_h = 0.15
@export var mouse_sensitivity_v = 0.15

#track if the player is dead
var dead = false

const HOTKEYS = {
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3,
	KEY_5: 4,
	KEY_6: 5,
	KEY_7: 6,
	KEY_8: 7,
	KEY_9: 8,
	KEY_0: 9,
	
}

#gets called at run time 
func _ready():
#captures the mouse
#hmouse mode captured the mouse will be hidden and its posttion locked at the center of the windows manager
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
#	when the signal emits that the player died itll call the kill funciton and update dead to true
	health_manager.died.connect(kill)

#input function is called whenever any form of input is done on the mouse by the player
#we want the mouse movedment now
func _input(event):
#	if the player is dead we dont also want the camera to be moved around
	if dead: return
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
	 
	if event is InputEventMouseButton  and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP: 
			weapon_manager.switch_to_previous_weapon()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN: 
			weapon_manager.switch_to_next_weapon()
	if event is InputEventKey and event.pressed and event.keycode in HOTKEYS:
		weapon_manager.switch_to_weapon_slot(HOTKEYS[event.keycode])
		
func _process(_delta):
	if Input.is_action_just_pressed("quit"): get_tree().quit()
	if Input.is_action_just_pressed("restart"): get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullscreen"):
		var win := get_window()
		if win.mode == Window.MODE_FULLSCREEN:
			win.mode = Window.MODE_WINDOWED
		else:
			win.mode = Window.MODE_FULLSCREEN
	
#	still want input but if the plauer is dead we dont want controller input from the player
	if dead: return
	
	#input durection for movement - only a 2d vector - good enough if it were only a top down 2 d game 
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	#here we convert the 2d vector into a 3D vector by adding horizontal movement
	#normalized prevents fast diagonal movement
	var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
#	update the players move direcitons with the function from character mover
	character_mover.set_move_dir(move_dir)
	
	if Input.is_action_just_pressed("jump"): 
		character_mover.jump()
		
func kill():
	dead = true
#	make it so player cannot move if you died
	character_mover.set_move_dir(Vector3.ZERO)
	

	
