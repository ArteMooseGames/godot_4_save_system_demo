extends CharacterBody2D
class_name Player

signal player_died

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

const speed: float = 200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var direction: Vector2 = Vector2.ZERO
var can_move: bool = false


func _physics_process(_delta):
	if can_move:
		direction = Vector2.ZERO
		# Get input
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_up"):
			direction.y -= 1 
		direction = direction.normalized()
		if direction:
			velocity = direction * speed
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
