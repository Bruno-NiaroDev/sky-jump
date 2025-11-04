extends Area2D

@onready var anim := $AnimatedSprite2D
@onready var collision := $CollisionShape2D

var elemento_valor := 1

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if collision:
			collision.set_deferred("disabled", true)

		if anim and anim.sprite_frames.has_animation("collect"):
			anim.play("collect")
			await $CollisionShape2D.call_deferred("queue_free")
			Globals.elements += elemento_valor
		else:
			queue_free()

func _on_AnimatedSprite2D_animation_finished() -> void:
	if anim.animation == "collect":
		queue_free()
