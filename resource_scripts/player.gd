class_name Player extends Resource

# Listen to when a mineral item amount is changed
signal mineral_amount_changed 

# Listen to when balance is changed
signal balance_changed

## Player's balance information of int data type
@export var balance: int = 10
## An array of Mine resource 
@export var quarry_slot_list: Array[QuarrySlot]
## Stores the amount of quarries in quarry collection that is not empty
@export var quarry_count: int = 0
## An array of Mineral Resources
@export var mineral_list: Array[MineralItem]

const MAX_PLAYER_QUARRY_CAPACITY: int = 3

# Call when mineral amoutn is changed
func emit_mineral_amount_change_signal() -> void:
	emit_signal("mineral_amount_changed")

func emit_balance_changed_signal() -> void:
	emit_signal("balance_changed")
