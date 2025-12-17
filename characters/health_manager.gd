extends Node3D

@export var max_health = 100
@onready var cur_health = max_health

#showers gore instead of a death animation
@export var gib_at = -10

#for debugging on and off in the inspector
@export var verbose = false

#signal that is emitted happens whenever any of these happend this is the way to declare events 
signal died
signal healed
signal damaged
signal gibbed 
signal health_changed(cur_health, max_health)

func _ready():
	health_changed.emit(cur_health, max_health)
	if verbose: print("starting health: ",cur_health, " and max health : ", max_health )

#player takes damage
func hurt(damage_data: DamageData): 
#	if its less then 0 then you're dead
	if cur_health <=0: return 
#	otherwise take damage away from overall health 
	cur_health -= damage_data.amount
	
#	the emit notifies all listeners of that event
	if cur_health <= gib_at: gibbed.emit()
	if cur_health <= 0:  died.emit()
	else: damaged.emit()
#	update the diffrence in health 
	health_changed.emit()
	health_changed.emit(cur_health, max_health)
	
	if verbose: print("damaged for: ", damage_data.amount, " current health",cur_health, " and max health : ", max_health )

func heal(amount:int):
#	if youre dead just return nothing
	if cur_health <= 0:return 
	cur_health = clamp(cur_health + amount, 0, max_health)
	healed.emit()
	health_changed.emit(cur_health, max_health)
	if verbose: print("healed for: ", amount, " current health",cur_health, " and max health: ", max_health )


#func test_damage():
	#var d = DamageData.new()
	#d.amount = 30
	#hurt(d)
