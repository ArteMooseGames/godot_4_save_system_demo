extends CanvasLayer

signal unpause
signal restart_game

@onready var back_button: Button = $ColorRect/ColorRect/VBoxContainer/BackButton
@onready var save_button: Button = $ColorRect/ColorRect/VBoxContainer/SaveButton
@onready var restart_button: Button = $ColorRect/ColorRect/VBoxContainer/RestartButton


func _ready():
	back_button.grab_focus()
	back_button.pressed.connect(_on_back_button_pressed)
	save_button.pressed.connect(_on_save_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)


func _on_back_button_pressed():
	unpause.emit()
	queue_free()


func _on_save_button_pressed():
	SaveLoad.save_game(Globals.current_level)
	get_tree().change_scene_to_file("res://scenes/menus/title_menu.tscn")


func _on_restart_button_pressed():
	SaveLoad.clear_save()
	restart_game.emit()
	queue_free()

