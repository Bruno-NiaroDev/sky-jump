extends Area2D

func _on_body_entered(body: Node2D) -> void:
	## Chamar DSL para contabilizar item coletado
	# dentro do planeta urano.
	print("+1 coin") 
	queue_free()
