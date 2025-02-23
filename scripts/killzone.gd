extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: CharacterBody2D) -> void:
	#print("You died")
	#print(area_entered)
	if body.has_method("die"):
		#print("call die")
		body.die()
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	
