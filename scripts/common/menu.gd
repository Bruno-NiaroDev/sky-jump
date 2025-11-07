extends Control

@onready var buttons := $buttons
@onready var form := $form
@onready var name_input := $form/input
@onready var error_label := $form/error_label

func _ready() -> void:
	buttons.visible = true
	form.visible = false
	error_label.visible = false


func _on_start_btn_pressed() -> void:
	buttons.visible = false
	form.visible = true
	


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_load_btn_pressed() -> void:
	get_tree().change_scene_to_file('res://screens/mapa.tscn')


func _on_ranking_btn_pressed() -> void:
	pass # Replace with function body.


func _on_confirm_btn_pressed() -> void:
	var nome = name_input.text.strip_edges()
	if nome == "":
		error_label.visible = true
	else:
		error_label.visible = false
		get_tree().change_scene_to_file('res://screens/info.tscn')
