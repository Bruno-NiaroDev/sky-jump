extends Control


func _on_retry_btn_pressed() -> void:
	Globals.block_levels = ["urano", "saturno", "jupiter", "marte", "terra"]
	Globals.player_life = 3
	Globals.selected_planet = ""
	get_tree().change_scene_to_file("res://screens/mapa.tscn")
	


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
