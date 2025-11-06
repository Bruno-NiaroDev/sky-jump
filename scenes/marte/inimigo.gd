extends Area2D

@export var speed: float = 30.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var left_bound: Marker2D = $LeftBound
@onready var right_bound: Marker2D = $RightBound

var direction: int = 1


func _ready() -> void:
	# Começa no ponto esquerdo
	position.x = left_bound.position.x
	sprite.play("walk")

func _process(delta: float) -> void:
	# Movimento simples (andar pra frente ou pra trás)
	position.x += direction * speed * delta

	# Verifica se chegou em um dos limites e inverte a direção
	if direction > 0 and position.x >= right_bound.position.x:
		direction = -1
		sprite.flip_h = true
	elif direction < 0 and position.x <= left_bound.position.x:
		direction = 1
		sprite.flip_h = false
