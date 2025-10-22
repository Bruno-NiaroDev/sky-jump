extends Camera2D

# --- CONFIGURAÇÕES PRINCIPAIS ---
@export var suavizacao_posicao: float = 0.15  # Suavização (0.05–0.2 é ideal)
@export var margem_segura: int = 16           # Margem para não mostrar fora do mapa
@export var seguir_player: NodePath           # Caminho para o Player (defina no editor)
@export var limitar_automaticamente: bool = true # Ajusta limites com base no mapa

var player_ref: Node2D = null

func _ready() -> void:
	# Referência ao player
	if seguir_player != null:
		player_ref = get_node(seguir_player)

	# Ativa esta câmera como a principal
	make_current()

	# Configura limites automaticamente, se habilitado
	if limitar_automaticamente:
		_configurar_limites()

func _physics_process(delta: float) -> void:
	if player_ref == null:
		return

	# Suaviza o movimento da câmera em direção ao player
	var alvo_posicao = player_ref.global_position
	global_position = global_position.lerp(alvo_posicao, suavizacao_posicao)

# --- AJUSTE AUTOMÁTICO DOS LIMITES ---
func _configurar_limites() -> void:
	var root = get_tree().get_current_scene()
	if root == null:
		return

	# Procura um StaticBody2D ou TileMap representando o cenário
	for child in root.get_children():
		if child is StaticBody2D or child is TileMap:
			# Obtém área aproximada do nó
			if child.has_method("get_used_rect"):
				var rect = child.get_used_rect()
				var cell_size = child.tile_set.tile_size if child.has_method("get_used_rect") else Vector2(32, 32)
				limit_left = int(rect.position.x * cell_size.x) - margem_segura
				limit_top = int(rect.position.y * cell_size.y) - margem_segura
				limit_right = int((rect.position.x + rect.size.x) * cell_size.x) + margem_segura
				limit_bottom = int((rect.position.y + rect.size.y) * cell_size.y) + margem_segura
			break
