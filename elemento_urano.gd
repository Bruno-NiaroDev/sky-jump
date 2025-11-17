extends Area2D

var elements := 1

func _on_body_entered(body: Node2D) -> void:
	Globals.elements += elements
	queue_free()
