extends Control

# Original resource files of player's data and quarry collection are added here
@export var player_data: Player
@export var quarry_data: QuarryCollection

# Player Balance Components
@onready var balance_ui: BalanceUI = %BalanceUI

# Player Mineral UI Components 
@onready var mineral_list_ui: MineralListUI = %MineralListUI

# Player Mine Slot Components
@onready var mine_slot_h_box_ui: HBoxContainer = %MineSlotHBoxUI

# Market UI Components
@onready var market_mineral_h_box_container: HBoxContainer = %MarketMineralHBoxContainer
@onready var selected_mineral_label: Label = %SelectedMineralLabel
@onready var price_label: Label = %PriceLabel
@onready var buy_quarry_button: Button = %BuyQuarryButton
@onready var sell_mineral_button: Button = %SellMineralButton

func _ready() -> void:
	# Create closure for each marekt mineral button
	for child: Button in market_mineral_h_box_container.get_children():
		child.pressed.connect(_on_market_mineral_button.bind(child))
	
	# Function assigned to buy button pressed signal
	buy_quarry_button.pressed.connect(_on_buy_quarry_button)
	
	# Enable buy quarry button when sold quarry singnal emitted
	for child: QuarrySlotUI in mine_slot_h_box_ui.get_children():
		child.sold_quarry.connect(
			func():
				buy_quarry_button.disabled = false
				)
				
	# set inital balance from player data
	balance_ui.set_balance(player_data.balance)
	
	# detects when balance signial is emitted and updates ui
	player_data.balance_changed.connect(
		func():
			balance_ui.set_balance(player_data.balance)
			)
	
	# increase balance when mineral sold and reduce mineral amount
	sell_mineral_button.pressed.connect(_on_sell_mineral_button)

# Updates the lael in market to selected mineral by comparing textures with stored quarry collection
func _on_market_mineral_button(button: Button) -> void:
	var mineral_sprite_texture: Texture
	# Ensure that there is only a sprites_2d node as child
	if button.get_child_count() == 1:
		mineral_sprite_texture = button.get_child(0).texture
	
	# Assign selected mineral's name to label text 
	for quarry: Quarry in quarry_data.quarry_collection:
		if mineral_sprite_texture == quarry.mineral.icon:
			selected_mineral_label.text = quarry.mineral.name
			price_label.text = "$" + str(quarry.buy_price)

# Add passed in quarry data to a empty player quarry slot
func add_quarry_to_player_slot(quarry: Quarry) -> void:
	for quarry_slot in player_data.quarry_slot_list:
		if quarry_slot.is_empty:
			quarry_slot.title = quarry.title
			quarry_slot.mineral = quarry.mineral
			quarry_slot.dig_rate = quarry.dig_rate
			quarry_slot.dig_duration = quarry.dig_duration
			quarry_slot.buy_price = quarry.buy_price
			quarry_slot.sell_price = quarry.sell_price
			
			# Change is_empty to false 
			quarry_slot.is_empty = false
			
			# Increment not empty quarry slot count
			player_data.quarry_count += 1
			
			# Pass added quarry data to quarry slot ui
			send_quarry_data_to_ui(quarry_slot)
			
			# Deduct from player balance the price of the quarry
			player_data.balance -= quarry_slot.buy_price
			player_data.emit_balance_changed_signal()
			break

	# Check if player quarry slots are full and, if true disable buy quarry button
	if player_data.quarry_count == player_data.MAX_PLAYER_QUARRY_CAPACITY:
		buy_quarry_button.disabled = true

# Takes a quarry input and updates the mine container ui
func send_quarry_data_to_ui(quarry: QuarrySlot) -> void:
	for quarry_slot_ui: QuarrySlotUI in mine_slot_h_box_ui.get_children():
		if quarry_slot_ui.is_empty:
			# Pass in the selected quarry data to player quarry slot
			quarry_slot_ui.data = quarry
			quarry_slot_ui.is_empty = false
			quarry_slot_ui.update_ui()
			break

# pass selected mineral quarry to the add quarry to player quarry slot function 
func _on_buy_quarry_button() -> void:
	for quarry: Quarry in quarry_data.quarry_collection:
		if selected_mineral_label.text == quarry.mineral.name:
			add_quarry_to_player_slot(quarry)

# add mineral sell price to balance and reduce from player's inventory
func _on_sell_mineral_button() -> void:
	for mineral: MineralItem in player_data.mineral_list:
		if selected_mineral_label.text == mineral.name:
			if mineral.amount > 0:
				player_data.balance += mineral.sell_price
				mineral.amount -= 1
				player_data.emit_balance_changed_signal()
				player_data.emit_mineral_amount_change_signal()
