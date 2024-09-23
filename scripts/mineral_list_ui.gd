class_name MineralListUI extends HBoxContainer

# Preload player data as this script is called before game script.
@onready var player_data: Player = preload("uid://cpwqm8j5d0dob")

# Access to all children of MineralListUI 
@onready var mineral_ui_collection: Array[MineralUI] = [%DuskeniteUI, %JarositeUI, %MoldaviteUI, %PallasiteUI, %ZyroniteUI]

func _ready() -> void:
	# Set the texture of minerals at runtime
	set_mineral_texture()
	
	# Connected function for when mineral amount changed signal is emitted.
	player_data.mineral_amount_changed.connect(update_amount_ui)

	
# Set the texture of the sprite 2d for each mineral ui to desired texture
func set_mineral_texture() -> void:
	for mineral in player_data.mineral_list:
		for mineral_ui in mineral_ui_collection:
			if not mineral_ui.is_updated:
				mineral_ui.icon_sprite_2d.texture = mineral.icon
				mineral_ui.is_updated = true
				break

# Update the mineral item ui amount label
func update_amount_ui() -> void:
	var index = 0
	for mineral_ui in mineral_ui_collection:
		mineral_ui.amount_label.text = str(player_data.mineral_list[index].amount)
		index += 1
