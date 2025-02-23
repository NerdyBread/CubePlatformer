extends AnimatableBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_triggerap_2_body_entered(body: Node2D) -> void:
	anim.play("move")
