extends CharacterBody2D
class_name Player

signal player_died

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

const SPEED = 200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var direction = Vector2.ZERO

func _physics_process(delta):
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
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	handle_anims(velocity)
	move_and_slide()


func handle_anims(velocity):
	if velocity == Vector2.ZERO:
		anim.play("idle")
	else:
		anim.play("run")
		sprite.flip_h = false
		if velocity.x < 0:
			sprite.flip_h = true
	


func _on_damage_hitbox_area_entered(area):
	emit_signal("player_died")
