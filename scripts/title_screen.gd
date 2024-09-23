extends CanvasLayer

@onready var start_game_button: Button = %StartGameButton

func _ready() -> void:
	start_game_button.pressed.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/game.tscn")
			)
