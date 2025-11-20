extends Node2D

@onready var player := $player as CharacterBody2D
@onready var player_scene = preload("res://scenes/common/characters/player.tscn")
@onready var camera := $camera as Camera2D
@onready var player_start_position: Marker2D = $player_start_position
@onready var fundo_sfx: AudioStreamPlayer = $sons/fundo_sfx

# Música da fase Marte
@onready var martian_music = preload("res://sounds/fundo musical.mp3")

func _ready() -> void:
	# Para música geral e inicia música da fase
	MusicManager.play_level_music(martian_music)

	Globals.reset_level()
	Globals.player_start_position = player_start_position
	Globals.player = player
	player.follow_camera(camera)
	Globals.player.player_has_died.connect(game_over)

func _process(delta: float) -> void:
	pass

func game_over():
	get_tree().change_scene_to_file("res://screens/game_over.tscn")
