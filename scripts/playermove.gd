extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -375.0
const DASH_SPEED = 800

var double_jump_allowed = true

var dash_allowed = true
var dashing = false
var dash_direction = 1

var dead = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var reload_timer: Timer = $Timer
@onready var dash_timer: Timer = $DashTimer


func start_dash():
	velocity.x += DASH_SPEED * dash_direction
	dash_timer.start()
	dashing = true
	dash_allowed = false

func cancel_dash():
	if dashing:
		velocity.x /= DASH_SPEED
		dashing = false
	
func _on_dash_timer_timeout() -> void:
	cancel_dash()
	
func jump():
	if dashing:
		cancel_dash()
		
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		double_jump_allowed = true
	elif double_jump_allowed:
		velocity.y = JUMP_VELOCITY
		double_jump_allowed = false
	
func handle_animation(direction):
		if direction > 0:
			dash_direction = 1
			animated_sprite.flip_h = true
		elif direction < 0:
			dash_direction = -1
			animated_sprite.flip_h = false
			
		if direction == 0 and not dead:
			animated_sprite.play("idle")
		elif not dead:
			animated_sprite.play("running")

func _physics_process(delta: float) -> void:
		# Handle jump
	if Input.is_action_just_pressed("jump"):
		jump()
			
	# Add the gravity.
	if not is_on_floor() and not dashing:
		velocity += get_gravity() * delta

	if is_on_floor():
		dash_allowed = true
		# Dash is restored each time player touches ground
		
	if Input.is_action_just_pressed("dash"):
		if dash_allowed: # and (velocity.x != 0) 
			start_dash()

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	handle_animation(direction)
	
	if not dashing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("reload"):
		die()
		reload_timer.start()

	move_and_slide()


func die() -> void:
	dead = true
	animated_sprite.play("death")

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
