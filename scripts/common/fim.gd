extends Area2D


@export var shrink_speed: float = 1.0
@export var spin_amount: float = 720.0 # graus de rotação
@export var pull_strength: float = 80.0 # intensidade da atração para o centro
@export var min_elements_collected := 0
@export var next_level_key = ""
@onready var particles := $GPUParticles2D
@onready var qty_elements_label: Label = $qty_elements_label
@onready var qty_min_elements: Label = $qty_min_elements

var player_abducting := false
var next_scene_path: String = "res://screens/mapa.tscn"

func _ready() -> void:
	qty_elements_label.text = str("%02d" % Globals.elements) + "/"
	qty_min_elements.text = str("%02d" % min_elements_collected)
	
func _process(delta: float) -> void:
	qty_elements_label.text = str("%02d" % Globals.elements) + "/"

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	# 🔒 Verifica se o jogador tem elementos suficientes
	if Globals.elements < min_elements_collected:
		
		reject_player(body)
		return

	# Se já estiver abduzindo, não faz nada
	if player_abducting:
		return

	player_abducting = true
	Globals.block_levels.erase(next_level_key)
	abduct_player(body)


# 🌀 Efeito de abdução (igual antes)
func abduct_player(player: Node2D) -> void:
	if "velocity" in player:
		player.velocity = Vector2.ZERO
	if "can_double_jump" in player:
		player.can_double_jump = false
	if "anim" in player and player.anim:
		player.anim.play("ocioso")

	if particles:
		particles.emitting = true

	var tween := get_tree().create_tween()
	var portal_center := global_position
	var duration := 1.2 / shrink_speed

	tween.parallel().tween_property(player, "global_position", portal_center, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(player, "rotation_degrees", player.rotation_degrees + spin_amount, duration)
	tween.parallel().tween_property(player, "scale", Vector2.ZERO, duration)
	tween.parallel().tween_property(player, "modulate:a", 0.0, duration)

	var camera := player.get_node_or_null("Camera2D")
	if camera:
		var cam_tween := get_tree().create_tween()
		cam_tween.tween_property(camera, "zoom", camera.zoom * 0.5, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(func():
		if is_instance_valid(player):
			player.queue_free()
		load_next_scene()
	)


# 🚫 Efeito de rejeição — empurra o player para fora
func reject_player(player: Node2D) -> void:
	# Calcula direção apenas no eixo X
	var dir_x = sign(player.global_position.x - global_position.x)
	if dir_x == 0:
		dir_x = 1  # caso raro: se estiver exatamente no centro, empurra para a direita

	var push_distance := 80.0
	var push_duration := 0.3

	# Cria o tween para empurrar somente no eixo X
	var tween := get_tree().create_tween()
	var target_pos := player.global_position + Vector2(dir_x * push_distance, 0)
	tween.tween_property(player, "global_position", target_pos, push_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Opcional: parar movimento e piscar partículas
	if "velocity" in player:
		player.velocity = Vector2.ZERO

	if particles:
		particles.emitting = true
		await get_tree().create_timer(0.3).timeout
		particles.emitting = false


func load_next_scene() -> void:
	Globals.selected_planet = next_level_key
	get_tree().change_scene_to_file(next_scene_path)
