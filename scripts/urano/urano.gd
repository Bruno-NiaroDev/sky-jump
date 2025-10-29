extends Node2D


@onready var player: CharacterBody2D = $player
@onready var camera: Camera2D = $camera


func _ready() -> void:
	player.follow_camera(camera)
