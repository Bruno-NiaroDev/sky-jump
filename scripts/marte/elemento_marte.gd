extends Area2D

@onready var anim := $anim as AnimatedSprite2D
@onready var collision := $collision as CollisionShape2D
@onready var coin_sfx: AudioStreamPlayer = $"../../sons/coin_sfx"



var elemento_valor := 1  # quanto o item vale

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	# Evita pegar duas vezes
	collision.disabled = true

	# Contabiliza o item
	Globals.elements += elemento_valor

	# Toca animação e som
	anim.play("collect")
	coin_sfx.play()

	# Espera o som terminar antes de remover o item
	queue_free()
	await coin_sfx.finished

	

	
	

	

	
