extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if Globals.check:
		animated_sprite.play("green")
	else:
		animated_sprite.play("red")
