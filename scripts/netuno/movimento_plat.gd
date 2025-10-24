extends Node2D

const WAIT_DURATION := 1.0

@onready var platform := $plataforma as AnimatableBody2D
@export var move_speed := 1000
@export var distance := 192.0
@export var move_horizontal := false

var follow := Vector2.ZERO

func _ready() -> void:
	move_platform()

func _process(delta: float) -> void:
	# Interpola a posição suavemente em direção a "follow"
	platform.position = platform.position.lerp(follow, 0.5)

func move_platform() -> void:
	# Define a direção do movimento (horizontal ou vertical)
	var move_direction := (Vector2.RIGHT if move_horizontal else Vector2.UP) * distance

	# Duração do movimento baseada na velocidade
	var duration := move_direction.length() / move_speed

	# Cria um Tween
	var platform_tween := create_tween()

	# Movimento de ida
	platform_tween.tween_property(self, "follow", follow + move_direction, duration)

	# Movimento de volta com espera
	platform_tween.tween_property(self, "follow", follow, duration).set_delay(WAIT_DURATION)

	# Loop infinito
	platform_tween.set_loops()
