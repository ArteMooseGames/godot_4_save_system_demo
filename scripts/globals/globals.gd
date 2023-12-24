extends Node


# Vars that do not get saved
var levels: Array = [
	"Level1",
	"Level2",
	"Level3",
	"Level4",
	"Level5",
]

var level_paths: Dictionary = {
	"Level1": "res://scenes/level_1.tscn",
	"Level2": "res://scenes/level_2.tscn",
	"Level3": "res://scenes/level_3.tscn",
	"Level4": "res://scenes/level_4.tscn",
	"Level5": "res://scenes/level_5.tscn",
}

var next_level: Dictionary = {
	"Level1": "Level2",
	"Level2": "Level3",
	"Level3": "Level4",
	"Level4": "Level5",
	"Level5": "",
}

# Vars that get saved
var current_level: String = "Level1"
var player_lives: int = 5
var player_position: Vector2 = Vector2(104, 104)  # This is the starting position on a new map
var coin_counter: Dictionary = {
	"star": 0,
	"diamond": 0,
}
var default_global_values: Dictionary = {
	"current_level": "Level1",
	"player_lives": 5,
	"player_position": Vector2(104, 104),
	"coin_counter": {
		"star": 0,
		"diamond": 0,
	},
}


# SAVING AND LOADING DATA FUNCTIONS
func save_data() -> Dictionary:
	var save_dict: Dictionary = {
		"current_level": current_level,
		"player_lives": player_lives,
		"player_pos_x": player_position.x,
		"player_pos_y": player_position.y,
		"coin_counter": coin_counter,
	}
	return save_dict


func load_data(data: Dictionary) -> void:
	current_level = data["current_level"]
	player_lives = data["player_lives"]
	player_position.x = data["player_pos_x"]
	player_position.y = data["player_pos_y"]
	coin_counter = data["coin_counter"]
