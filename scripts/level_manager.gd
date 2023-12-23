extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var player_start: Marker2D = $PlayerStartMarker
@onready var end_door: Area2D = $EndDoor
@onready var hud: CanvasLayer = $HUD
@onready var popup: CanvasLayer = $Popup
@onready var popup_label: Label = $Popup/ColorRect/ColorRect/Label

@onready var PauseMenu := load("res://scenes/menus/pause_menu.tscn")


func _ready():
	hud.update_level_label(name)
	hud.update_lives_label(Globals.player_lives)
	player.player_died.connect(_on_player_died)
	end_door.end_door_entered.connect(_on_level_finished)
	SaveLoad.load_game(name)
	Globals.current_level = name
	player.global_position = Globals.player_position
	player.can_move = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_pause()


func _process(_delta):
	hud.update_star_label(Globals.coin_counter["star"])
	hud.update_diamond_label(Globals.coin_counter["diamond"])


func _pause() -> void:
	player.can_move = false
	var pause_menu: Object = PauseMenu.instantiate()
	add_child(pause_menu)
	pause_menu.unpause.connect(_unpause)
	pause_menu.restart_game.connect(_restart_game)


func _unpause() -> void:
	player.can_move = true


func _restart_game() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_player_died() -> void:
	player.can_move = false
	if Globals.player_lives >= 2:
		Globals.player_lives -= 1
	else:
		popup_label.text = "Oops...\nYou ran out of lives."
		SaveLoad.clear_save()
		popup.visible = true
		await get_tree().create_timer(2).timeout
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level_1.tscn")
	Globals.player_position = player_start.global_position  # Player goes back to start
	SaveLoad.save_game(name)
	get_tree().call_deferred("reload_current_scene")


func _on_level_finished() -> void :
	player.can_move = false
	# might want to pull up a "Finished" screen here, to hide that we're moving the player
	Globals.player_position = player_start.global_position  # need to reset player position for next level
	SaveLoad.save_game(name)
	# scene transition to next scene (for now just reload current scene)
	if name != "Level5":
		popup_label.text = "Success!\n Next level incoming..."
		popup.visible = true
		await get_tree().create_timer(2).timeout
		get_tree().call_deferred("change_scene_to_file", Globals.level_paths[Globals.next_level[name]])
		
	else:
		popup_label.text = "Success!\n You beat the game!"
		SaveLoad.clear_save()
		popup.visible = true
		await get_tree().create_timer(2).timeout
		get_tree().call_deferred("change_scene_to_file", "res://scenes/menus/title_menu.tscn")
