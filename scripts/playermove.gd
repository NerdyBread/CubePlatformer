extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -325.0

var dead = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
	if direction > 0:
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.flip_h = false
		
	if direction == 0 and not dead:
		animated_sprite.play("idle")
	elif not dead:
		animated_sprite.play("running")

	if Input.is_action_just_pressed("reload"):
		print("reload")
		die()
		timer.start()

	move_and_slide()


func die() -> void:
	#print("access die")
	dead = true
	animated_sprite.play("death")
	


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
