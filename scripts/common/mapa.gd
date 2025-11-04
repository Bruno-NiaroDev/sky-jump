extends Node2D

@onready var load_btn = $load_btn
@onready var subtitulo = $subtitulo
@onready var planet_nodes = $planets.get_children() # todos os planetas dentro de "Planets"

func _ready() -> void:
	# Conecta sinais de todos os planetas
	for planet in planet_nodes:
		if planet.has_signal("select_planet"):
			planet.select_planet.connect(Callable(self, "_on_planet_selected"))
	
	# Configura a UI inicial
	_update_ui()

func _on_planet_selected(clicked_planet) -> void:
	_update_ui()

func _update_ui() -> void:
	if Globals.selected_planet != "":
		load_btn.visible = true
		subtitulo.visible = false
	else:
		load_btn.visible = false
		subtitulo.visible = true


func _on_load_btn_pressed() -> void:
	var path = Globals.selected_planet
	get_tree().change_scene_to_file("res://screens/planets/%s_intro.tscn" % path)
