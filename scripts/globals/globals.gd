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

var points_per_level: Dictionary = {
	"Level1": 0,
	"Level2": 0,
	"Level3": 0,
	"Level4": 0,
	"Level5": 0,
}
