extends Node2D

@export var planet_name: String = ""
@export var planet_sprite: Texture
@export var planet_key: String = ""
@onready var sprite = $btn/sprite
@onready var label = $planet_name
var tween: Tween
var locked := true

signal select_planet()

func _ready():
	# Verifica se o planeta está bloqueado
	locked = Globals.block_levels.has(planet_key)

	# Configura sprite e texto
	label.text = planet_name
	sprite.texture = planet_sprite
	tween = create_tween()
	sprite.scale = Vector2.ONE  # escala base

	# Ajusta visual conforme bloqueio
	if locked:
		modulate = Color(0.5, 0.5, 0.5, 0.7)
	else:
		modulate = Color(1, 1, 1, 1)
		label.modulate = Color(1, 1, 1, 1)

	# Atualiza visual se já é o planeta selecionado
	_update_selection_visual()


func _process(delta):
	# Atualiza visual a cada frame para refletir o planeta selecionado
	_update_selection_visual()


func _on_btn_mouse_entered() -> void:
	if locked or Globals.selected_planet == planet_key:
		return
	tween.kill()
	tween = create_tween() 
	tween.tween_property(sprite, "scale", Vector2(1.1, 1.1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_btn_mouse_exited() -> void:
	if locked or Globals.selected_planet == planet_key:
		return
	tween.kill()
	tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_btn_pressed() -> void:
	if locked or Globals.selected_planet == planet_key:
		return

	# Atualiza a seleção global
	Globals.selected_planet = planet_key
	emit_signal("select_planet", self)

	# Aplica o efeito de escala selecionado
	tween.kill()
	tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.1, 1.1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	

func _update_selection_visual():
	if Globals.selected_planet == planet_key:
		sprite.scale = Vector2(1.1, 1.1)
		label.modulate = Color(0.776, 0.224, 0.878) # cor #c639e0
	else:
		sprite.scale = Vector2.ONE
		label.modulate = Color(1, 1, 1, 1)
