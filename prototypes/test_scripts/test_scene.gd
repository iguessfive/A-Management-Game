extends Control

enum trade_state {SELL, BUY}

@onready var button: Button = $Button
@onready var state := trade_state.SELL


var data = {
	"first": "click me to find out"
}

func _ready() -> void:
	button.pressed.connect(
		func(): 
			if state == trade_state.SELL:
				print("true")
				print(trade_state.keys()[state])
				state = trade_state.BUY
				print(type_string(typeof(state)))
			else:
				print("false")
				print(trade_state.keys()[state])
				state = trade_state.SELL
			)
	
	button.text = data["first"]
	data["first"] = "yep, clicky click"
	print(data["first"])
	

