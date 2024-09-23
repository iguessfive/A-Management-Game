class_name MineralUI extends PanelContainer

# Set to true when desired texture is assigned to icon sprite 2d
@export var is_updated: bool = false

@onready var icon_sprite_2d: Sprite2D = %IconSprite2D
@onready var amount_label: Label = %AmountLabel
