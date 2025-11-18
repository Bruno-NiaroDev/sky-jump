extends Area2D

@onready var animation:= $anim as AnimatedSprite2D
@onready var coin_sfx: AudioStreamPlayer = $"../../sons/coin_sfx"

var pocoes := 1

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	animation.play("collect")
	coin_sfx.play()
	# Evita a colisão dupla de moeda
	await $collision.call_deferred("queue_free")
	Globals.elements += pocoes
	


func _on_anim_animation_finished() -> void:
	if animation.animation == "collect":
		
		
		queue_free()
		await coin_sfx.finished
