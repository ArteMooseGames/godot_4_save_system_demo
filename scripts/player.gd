extends CharacterBody2D


const SPEED = 400.0

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
	move_and_slide()
