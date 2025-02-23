extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	animated_sprite.play("left")
	if body.has_method("levelUp"):
		body.levelUp()
