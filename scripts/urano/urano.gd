extends Node2D


@onready var player := $player as CharacterBody2D
@onready var player_scene = preload("res://scenes/common/characters/player.tscn")
@onready var camera: Camera2D = $camera
@onready var control := $HUD/control as  Control
@onready var player_start_position: Marker2D = $player_start_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player = player
	Globals.player_start_position = player_start_position
	player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func reload_game():
	await get_tree().create_timer(1.0).timeout
	var player = player_scene.instantiate()
	add_child(player)
	control.reset_clock_timer()
	Globals.player = player
	player.follow_camera(camera)
	Globals.player.player_has_died.connect(game_over)
	Globals.elements = 0
	Globals.player_life = 3
	Globals.respawn_player()
	
func game_over():
	print('você morreu')
	#get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
