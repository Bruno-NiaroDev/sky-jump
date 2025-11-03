extends CharacterBody2D

const box_pieces = preload("res://scenes/jupiter/box_pieces.tscn")
const pocoes_instance = preload("res://scenes/jupiter/pocoes_rigid.tscn")

@onready var animation_player := $anim as AnimationPlayer
@onready var spawn_coin := $spawn_coin as Marker2D
@export var pieces : PackedStringArray
@export var hitpoints := 3
var impulse := 200


func break_sprite():
	for path in pieces:
		var piece_instance = box_pieces.instantiate()
		get_parent().add_child(piece_instance)
		piece_instance.get_node("texture").texture = load(path)
		piece_instance.global_position = global_position
		piece_instance.apply_impulse(Vector2(
			randi_range(-impulse, impulse),
			randi_range(-impulse, -impulse * 2)
		))
	queue_free()


func create_coin():
	var pocoes = pocoes_instance.instantiate()
	get_parent().call_deferred("add_child", pocoes)
	pocoes.global_position = spawn_coin.global_position
	pocoes.apply_impulse(Vector2(
		randi_range(-50, 50),
		-100
	))
