extends Node3D

#the export function makes these variables changeable in the editor
@export var jump_force = 15.0
@export var gravity = 30.0
@export var max_speed = 15.0
@export var move_accel = 4.0
#how quickly movement slows when no input is applied 
@export var stop_drag = 0.9

var character_body : CharacterBody3D
# calculates how much acceleration is applied per frame - which  makes acceleration scale correctly with speed
var move_drag = 0.0
var move_dir: Vector3

func _ready():
	character_body = get_parent()
	move_drag = float(move_accel) / max_speed
#sets the direction	
func set_move_dir(new_move_dir: Vector3): move_dir = new_move_dir

func jump():
	if character_body.is_on_floor():
#		applies jumpforce upward
		character_body.velocity.y = jump_force

#delta is the time since the last frame
func _physics_process(delta):
#	prevents getting stuck in the ceiling
	if character_body.velocity.y > 0.0 and character_body.is_on_ceiling(): character_body.velocity.y = 0.0
#	make sure that if we're not on the floor then we are falling
	if not character_body.is_on_floor(): character_body.velocity.y -= gravity * delta
	
#	drag 
	var drag = move_drag
	if move_dir.is_zero_approx(): drag = stop_drag
	
	var flat_velo = character_body.velocity
	flat_velo.y = 0.0
	character_body.velocity += move_accel * move_dir - flat_velo * drag
	character_body.move_and_slide()
	
		
