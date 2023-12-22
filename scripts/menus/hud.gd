extends CanvasLayer

@onready var level_label: Label = $VBoxContainer/CurrentLevelLabel
@onready var lives_label: Label = $VBoxContainer/LivesLabel
@onready var star_label: Label = $VBoxContainer/StarLabel
@onready var diamond_label: Label = $VBoxContainer/DiamondLabel



func update_level_label(level_name: String) -> void:
	level_label.text = level_name.left(5) + " " + level_name.right(1)


func update_lives_label(lives: int) -> void:
	lives_label.text = "No. Lives: " + str(lives)


func update_star_label(count: int) -> void:
	star_label.text = "Star Coins: " + str(count)


func update_diamond_label(count: int) -> void:
	diamond_label.text = "Diamond Coins: " + str(count)
