extends Node2D

const WAIR_DURATION := 1.0

@onready var platform := $plataform as AnimatableBody2D
@export var move_speed := 1.5 # VALOR ALTERADO para deixar mais lento
@export var distance := 192
@export var move_horizontal := true 

var follow := Vector2.ZERO
var platform_center := 64

func _ready() -> void:
	move_platform() 

func _process(delta: float) -> void:
	platform.position = platform.position.lerp(follow, 0.5)
	
func move_platform():
	var move_direction = Vector2.RIGHT * distance if move_horizontal else Vector2.UP * distance 
	
	# O valor de 'duration' será maior porque 'move_speed' é menor
	var duration = move_direction.length() / float(move_speed * platform_center)
	
	var platform_tween = create_tween()
	
	# Movimento de ida
	platform_tween.tween_property(self, "follow", follow + move_direction, duration)
	
	# Movimento de volta com atraso
	platform_tween.tween_property(self, "follow", follow, duration).set_delay(WAIR_DURATION)
	
	platform_tween.set_loops()
