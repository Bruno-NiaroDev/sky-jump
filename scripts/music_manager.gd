extends Node

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"  # opcional, mas recomendado

# Toca música do menu se não estiver tocando
func play_menu_music(stream):
	if not music_player.playing:
		music_player.stream = stream
		music_player.play()

# Para a música do menu ao entrar na fase
func stop_menu_music():
	if music_player.playing:
		music_player.stop()
