extends Area2D

@export var next_scene_path: String = "res://scenes/jupiter/jupiter.tscn"
@export var shrink_speed: float = 1.0
@export var spin_amount: float = 720.0 # graus de rotação
@export var pull_strength: float = 80.0 # intensidade da atração para o centro
@onready var particles := $GPUParticles2D

var player_abducting := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not player_abducting:
		player_abducting = true
		print("Portal ativado! Iniciando abdução cinematográfica...")
		abduct_player(body)

func abduct_player(player: Node2D) -> void:
	# Desativa movimento e animações
	if "velocity" in player:
		player.velocity = Vector2.ZERO
	if "can_double_jump" in player:
		player.can_double_jump = false
	if "anim" in player and player.anim:
		player.anim.play("ocioso")

	# Liga partículas do portal
	if particles:
		particles.emitting = true

	# Cria tween global
	var tween := get_tree().create_tween()
	var portal_center := global_position
	var duration := 1.2 / shrink_speed

	# Puxa player pro centro do portal
	tween.parallel().tween_property(player, "global_position", portal_center, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# Faz o player girar, sumir e encolher
	tween.parallel().tween_property(player, "rotation_degrees", player.rotation_degrees + spin_amount, duration)
	tween.parallel().tween_property(player, "scale", Vector2.ZERO, duration)
	tween.parallel().tween_property(player, "modulate:a", 0.0, duration)

	# 🎥 Efeito de câmera (zoom leve)
	var camera := player.get_node_or_null("Camera2D")
	if camera:
		var cam_tween := get_tree().create_tween()
		cam_tween.tween_property(camera, "zoom", camera.zoom * 0.5, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Quando o tween terminar, troca a cena
	tween.finished.connect(func():
		print("Abdução concluída. Carregando próxima cena...")
		if is_instance_valid(player):
			player.queue_free()
		load_next_scene()
	)

func load_next_scene() -> void:
	get_tree().change_scene_to_file(next_scene_path)
