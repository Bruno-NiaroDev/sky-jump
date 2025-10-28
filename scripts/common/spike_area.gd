extends Area2D

@onready var texture: Sprite2D = $texture as Sprite2D
@onready var collision: CollisionShape2D = $collision as CollisionShape2D

@export var repeat_object: int = 1:
	set(value):
		repeat_object = max(value, 1)
		_update_spikes()

# Armazena o tamanho original do frame recortado no editor
var base_region_size: Vector2

func _ready() -> void:
	# Guarda o tamanho base uma única vez, ao iniciar
	if texture and texture.texture:
		base_region_size = texture.region_rect.size
	_update_spikes()

func _update_spikes() -> void:
	if not texture or not texture.texture:
		return

	# Se ainda não temos o tamanho base (por exemplo, em tempo de edição inicial)
	if base_region_size == Vector2.ZERO:
		base_region_size = texture.region_rect.size

	texture.region_enabled = true

	# Define o tamanho da região com base no frame original, não no valor já expandido
	texture.region_rect.size = Vector2(base_region_size.x * repeat_object, base_region_size.y)

	# Atualiza a colisão para o mesmo tamanho visual
	if collision and collision.shape:
		collision.shape.size = Vector2(base_region_size.x * repeat_object, base_region_size.y)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -200))
