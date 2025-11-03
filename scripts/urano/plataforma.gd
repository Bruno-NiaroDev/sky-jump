extends Node2D

const WAIT_DURATION := 0

@onready var platform := $plataforma as AnimatableBody2D
@export var move_speed := 100
@export var distance := 240.0
@export var move_horizontal := false

var follow := Vector2.ZERO

func _ready() -> void:
	move_platform()

func _process(delta: float) -> void:
	platform.position = platform.position.lerp(follow, 0.5)

func move_platform() -> void:
	var move_direction := (Vector2.RIGHT if move_horizontal else Vector2.LEFT) * distance

	var duration := move_direction.length() / move_speed

	var platform_tween := create_tween()

	platform_tween.tween_property(self, "follow", follow + move_direction, duration)

	platform_tween.tween_property(self, "follow", follow, duration).set_delay(WAIT_DURATION)

	platform_tween.set_loops()
