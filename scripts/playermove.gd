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
@onready var reload_timer: Timer = $ReloadTimer
@onready var dash_timer: Timer = $DashTimer
@onready var level_timer: Timer = $LevelTimer

func _ready():
	if Globals.check == true:
		position = Vector2(2095, -401)

func switch_level():
	get_tree().change_scene_to_file("res://scenes/Level2.tscn")

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
			if dashing:
				animated_sprite.play("dash")
			else:
				animated_sprite.play("running")

func _physics_process(delta: float) -> void:
	if not dead:
		## TODO Delete this
		#if Input.is_action_just_pressed("level2"):
			#switch_level()
		
			# Handle jump
		if Input.is_action_just_pressed("jump"):
			jump()
				
		# Add the gravity.
		if not is_on_floor() and not dashing:
			velocity += get_gravity() * delta

		if is_on_floor():
			dash_allowed = true
			double_jump_allowed = true
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
	velocity.x = 0
	velocity.y = 0
	animated_sprite.play("death")
	velocity.x = 0
	velocity.y = 0


func _on_checkpoint_body_entered(body: Node2D) -> void:
	Globals.check = true


func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()
	
func levelUp() -> void:
	Globals.check = false
	level_timer.start()

func _on_level_timer_timeout() -> void:
	switch_level()
