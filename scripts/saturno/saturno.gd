extends Node2D


@onready var player := $player as CharacterBody2D
@onready var player_scene = preload("res://scenes/common/characters/player.tscn")
@onready var camera := $camera as Camera2D
@onready var control := $HUD/control as  Control
@onready var player_start_position: Marker2D = $player_start_position
@onready var fundo_sfx: AudioStreamPlayer = $sons/fundo_sfx

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.reset_level()
	Globals.player_start_position = player_start_position
	Globals.player = player
	player.follow_camera(camera)
	Globals.player.player_has_died.connect(game_over)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func game_over():
	get_tree().change_scene_to_file("res://screens/game_over.tscn")
