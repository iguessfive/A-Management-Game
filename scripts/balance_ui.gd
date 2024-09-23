class_name BalanceUI extends PanelContainer

@onready var data: Player

@onready var amount_label: Label = %AmountLabel

# set balance to amont label text property
func set_balance(new_balance: int) -> void: 
	amount_label.text = str(new_balance)
