extends Node2D


func _on_next_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://screens/ranking.tscn")
