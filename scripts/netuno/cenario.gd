extends Node2D

@onready var player := $player as CharacterBody2D
@onready var player_scene = preload("res://scenes/common/characters/player.tscn")
@onready var camera := $camera as Camera2D
@onready var control := $HUD/control as Control

# Música da fase Netuno
@onready var netuno_music = preload("res://sounds/fundo musical.mp3")

func _ready() -> void:
	# Para a música geral e toca a música da fase
	MusicManager.play_level_music(netuno_music)

	Globals.reset_level()
	Globals.player = player
	player.follow_camera(camera)
	Globals.player.player_has_died.connect(game_over)

func _process(delta: float) -> void:
	pass

func game_over():
	get_tree().change_scene_to_file("res://screens/game_over.tscn")
