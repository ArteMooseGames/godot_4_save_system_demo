class_name Player
extends CharacterBody2D

signal player_died

const SPEED: float = 200.0

var can_move: bool = false
var _direction: Vector2 = Vector2.ZERO

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D


func _physics_process(_delta):
	if can_move:
		_direction = Vector2.ZERO
		# Get input
		if Input.is_action_pressed("move_right"):
			_direction.x += 1
		if Input.is_action_pressed("move_left"):
			_direction.x -= 1
		if Input.is_action_pressed("move_down"):
			_direction.y += 1
		if Input.is_action_pressed("move_up"):
			_direction.y -= 1 
		_direction = _direction.normalized()
		if _direction:
			velocity = _direction * SPEED
		else:
			velocity = Vector2.ZERO
		_handle_anims()
		move_and_slide()
		_update_player_position()


func _handle_anims():
	if velocity == Vector2.ZERO:
		anim.play("idle")
	else:
		anim.play("run")
		sprite.flip_h = false
		if velocity.x < 0:
			sprite.flip_h = true


func _update_player_position():
	# Here we are keeping track of player position in the event that the game is saved and closed
	#	outside of a death/new level spawn.
	Globals.player_position = global_position


func _on_damage_hitbox_area_entered(_area):
	emit_signal("player_died")
