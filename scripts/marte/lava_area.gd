extends Area2D

# Essa função roda assim que o jogo começa
func _ready() -> void:
	# Conecta o evento de colisão: quando algo entra na lava
	connect("body_entered", Callable(self, "_on_body_entered"))

# Essa função é chamada automaticamente quando algo toca a lava
func _on_body_entered(body: Node2D) -> void:
	# Verifica se o objeto que tocou é o jogador
	if body.is_in_group("player"):
		print("🔥 Jogador caiu na lava!")

		# Se o jogador tiver uma função de morte, chama ela
		if body.has_method("die"):
			body.die()
		else:
			# Se não tiver, reinicia a fase
			get_tree().reload_current_scene()
