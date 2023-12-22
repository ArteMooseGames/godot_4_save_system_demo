extends CanvasLayer

@onready var new_game_button: Button = $ColorRect/ColorRect/VBoxContainer/NewGameButton
@onready var continue_button: Button = $ColorRect/ColorRect/VBoxContainer/ContinueButton


func _ready():
	new_game_button.grab_focus()
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)


func _on_new_game_button_pressed():
	SaveLoad.clear_save()
	get_tree().change_scene_to_file(Globals.level_paths["Level1"])


func _on_continue_button_pressed():
	get_tree().change_scene_to_file(Globals.level_paths[Globals.current_level])
