extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var player_start: Marker2D = $PlayerStartMarker

func _ready():
	player.player_died.connect(_on_player_died)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_died():
	Globals.player_lives -= 1
	print_debug(Globals.player_lives)
	print_debug("Player died")
	player.global_position = player_start.global_position

# Game will be relatively simple
# Scenes
# 	Levels (1 & 2)
# 	Player
# 	Coins (2 types)
# 	Hazards (1 type) lots of these so the point is to move around and get coins without dying
# 	End portal (takes you to next level, or success screen)
# 	HUD (Shows lives and currency)
# 	Pause menu (Reset game, Quit to title)
# 	Title (Start Game, Credits)
# 	You won! screen.

# Track
# 	Player Lives
# 	Coin counts

# Save system will implement
# 	What level was a player last in? 
# 	What is the currency count?
# 	How many lives does a player have left?

