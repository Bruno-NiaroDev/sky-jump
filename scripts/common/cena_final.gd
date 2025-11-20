extends Control

@onready var ultimo_sfx: AudioStreamPlayer = $ultimo_sfx

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://screens/cena_familia.tscn")
