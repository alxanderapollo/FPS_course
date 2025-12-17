extends Node3D
@onready var  weapons = $Weapons.get_children()
var weapons_unlocked = []
var cur_slot = 0
var cur_weapon = null

func _ready():
#	when we start we want all the weapons to be disabled
	disable_all_weapons()
	for weapon_that_exists in range(weapons.size()): weapons_unlocked.append(true)
	
	
func disable_all_weapons():
	for weapon in weapons:
		if has_method("set_active"): weapon.set_active(false)
		else: weapon.hide()
	

func switch_to_previous_weapon():
	var wrapped_index = wrapi(cur_slot - 1, 0, weapons.size())
	switch_to_weapon_slot(wrapped_index)

func switch_to_next_weapon():
	pass

func switch_to_weapon_slot(slot_index: int) -> bool:
	return false
	
