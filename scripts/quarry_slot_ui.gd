class_name QuarrySlotUI extends Control


# preload player data as this script is called before game script.
@onready var player_data = preload("uid://cpwqm8j5d0dob")

# data for a given quary slot
@onready var data: QuarrySlot

# check if mininig slot is empty
@onready var is_empty = true

# check if mine is active
@onready var is_mining = false

# ui components
@onready var title_label: Label = %TitleLabel
@onready var dig_button: Button = %DigButton
@onready var dig_progress_bar: ProgressBar = %DigProgressBar
@onready var sell_button: Button = %SellButton
@onready var dig_timer: Timer = %DigTimer

# Called in game _ready func
signal sold_quarry

func _ready() -> void:
	# connected functinon to dig button to start digging process 
	dig_button.pressed.connect(_on_dig_button)
	
	# prevent player from pressing quarry buttons if empty
	if is_empty:
		dig_button.disabled = true
		sell_button.disabled = true
	
	# connect timeout to a function call 
	dig_timer.timeout.connect(
		func():
			# when mining is over
			is_mining = false
			dig_button.disabled = false
			sell_button.disabled = false
			add_mined_mineral_to_player_mineral_collection()
	)
	
	# reset slot and update balance when sell button is pressed
	sell_button.pressed.connect(_on_sell_button)
	

func _process(_delta: float) -> void:
	# update the progress bar based on the time passed
	if is_mining:
		var dig_time_passed = (dig_timer.wait_time - dig_timer.time_left)
		dig_progress_bar.ratio = dig_time_passed / dig_timer.wait_time 
		dig_progress_bar.value = dig_progress_bar.ratio * 100

# update the UI components based on the player quarry data
func update_ui() -> void:
	# assign data to corresponding ui elements 
	title_label.text = data.title
	dig_timer.wait_time = data.dig_duration
	
	# when quarry is not empty enable quarry button ui
	if not is_empty:
		dig_button.disabled = false
		sell_button.disabled = false

# when timer ends add mineral from corresponding quarry to player's collection
func add_mined_mineral_to_player_mineral_collection() -> void:
	for mineral_item: MineralItem in player_data.mineral_list:
		if data.mineral.icon == mineral_item.icon:
			# adds mineral based on quarry's dig rate
			mineral_item.amount += data.dig_rate
			# call method on player_data resource for when mineral amount changed
			player_data.emit_mineral_amount_change_signal()

# start mining timer when dig button pressed
func _on_dig_button() -> void:
	# start timer
	dig_timer.start()
	
	# When mining set to true
	is_mining = true
	
	# Disable quarry button when mining
	dig_button.disabled = true
	sell_button.disabled = true
	
func _on_sell_button() -> void:
	# change title to default 
	title_label.text = data.default_title
	# reset progress bar
	dig_progress_bar.value = 0
	# slot now empty
	is_empty = true
	# player slot now empty
	data.is_empty = true
	# reduce player quarry count
	player_data.quarry_count -= 1
	# disable quarry slot buttons
	dig_button.disabled = true
	sell_button.disabled = true
	
	# Update balance for sold quarry price
	player_data.balance += data.sell_price
	player_data.emit_balance_changed_signal()

	# check if quarry count is less than max quarry count and emit sold quarry signal
	if player_data.quarry_count < player_data.MAX_PLAYER_QUARRY_CAPACITY:
		emit_signal("sold_quarry")
