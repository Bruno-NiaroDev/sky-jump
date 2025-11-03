extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("You died!")
	Engine.time_scale = 0.5
	## TO DO - Definir collision do player com esse nome: "CollisionPlayer"
	## body.get_node("colision").queue_free()
	timer.start()

func _on_timer_timeout() -> void:
	print("Restarting level")
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
