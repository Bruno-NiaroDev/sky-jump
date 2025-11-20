extends Node

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"  # opcional


# --- MENU ---
func play_menu_music(stream):
	if not music_player.playing:
		music_player.stream = stream
		music_player.play()

func stop_menu_music():
	if music_player.playing:
		music_player.stop()


# --- FASES ---
func play_level_music(stream):
	# Sempre para qualquer música anterior
	if music_player.playing:
		music_player.stop()

	music_player.stream = stream
	music_player.play()
