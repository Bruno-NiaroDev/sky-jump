extends Area2D

@onready var anim := $anim
@onready var collision := $collision

var elemento_valor := 1  # quanto esse item vale

func _ready() -> void:
	# Quando algo encostar, chama a função de coleta
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	# Garante que só o jogador pode coletar
	if body.is_in_group("player"):
		# Desativa colisão pra não coletar duas vezes
		collision.set_deferred("disabled", true)
		# Atualiza o contador global
		Globals.elements += elemento_valor
		# Toca animação (se existir)
		if anim.has_animation("collect"):
			anim.play("collect")
		else:
			queue_free()  # se não tem animação, só some

func _on_anim_animation_finished() -> void:
	# Quando a animação "collect" acabar, remove o item
	if anim.animation == "collect":
		queue_free()
