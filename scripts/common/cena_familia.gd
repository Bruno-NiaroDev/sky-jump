extends Node2D

@onready var fim_sfx: AudioStreamPlayer = $fim_sfx

func _on_next_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://screens/ranking.tscn")
