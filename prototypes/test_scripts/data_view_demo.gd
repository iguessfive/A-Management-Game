extends Control

@onready var increment_button: Button = $IncrementButton
@onready var current_count_value: Label = $CurrentCountValue

var counter_variable: int = 0

func update_count() -> void:
	var increment := 1
	counter_variable += increment

func update_count_ui() -> void:
	current_count_value.text = str(counter_variable)
	
func _on_button_pressed() -> void:
	update_count()
	update_count_ui()
	
func _ready() -> void:
	current_count_value.text = str(counter_variable)
	increment_button.pressed.connect(_on_button_pressed)
