extends CharacterBody2D

# ==========================
# CONFIGURAÇÕES DO INIMIGO
# ==========================
@export var speed: float = 60.0
@export var gravity: float = 800.0
@export var damage_force: float = 250.0
@export var bounce_force: float = 340.0
@export var death_animation_name: String = "die"

# ==========================
# VARIÁVEIS INTERNAS
# ==========================
var direction: int = 1
var is_dead: bool = false
var can_flip: bool = true  # impede virar rápido demais

# ==========================
# NÓS INTERNOS
# ==========================
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stomp_area: Area2D = $stomp_area
@onready var hurt_area: Area2D = $hurt_area
@onready var wall_check: RayCast2D = $wall_check

# ==========================
# READY
# ==========================
func _ready() -> void:
	# conecta sinais das áreas
	if stomp_area:
		stomp_area.connect("body_entered", Callable(self, "_on_stomp_area_body_entered"))
	if hurt_area:
		hurt_area.connect("body_entered", Callable(self, "_on_hurt_area_body_entered"))

	# toca animação inicial
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
		sprite.play("walk")

# ==========================
# MOVIMENTO
# ==========================
func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# aplica gravidade
	velocity.y += gravity * delta

	# movimento horizontal
	velocity.x = direction * speed

	# move com colisão
	move_and_slide()

	# vira se colidir com uma parede
	if wall_check.is_colliding():
		print("teste")
		_flip_direction()

	# animação
	if sprite and (not sprite.is_playing() or sprite.animation != "walk"):
		sprite.play("walk")

	# flip visual
	if sprite:
		sprite.flip_h = direction < 0

# ==========================
# VIRAR DIREÇÃO
# ==========================
func _flip_direction() -> void:
	if not can_flip:
		return

	can_flip = false
	direction *= -1
	sprite.flip_h = direction < 0

	# inverte o lado do RayCast
	if wall_check:
		wall_check.position.x *= -1

	print("🔁 Inimigo virou! Direção atual:", direction)

	# espera 0.3s antes de permitir virar novamente
	await get_tree().create_timer(0.3).timeout
	can_flip = true

# ==========================
# PISÃO DO JOGADOR
# ==========================
func _on_stomp_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if body.has_method("bounce_on_enemy"):
		body.bounce_on_enemy(bounce_force)
	elif "velocity" in body:
		body.velocity.y = -bounce_force

	_die()

# ==========================
# DANO AO TOCAR
# ==========================
func _on_hurt_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var knockback_dir: Vector2 = (body.global_position - global_position).normalized() * damage_force

	if body.has_method("take_damage"):
		body.take_damage(knockback_dir)
	elif "velocity" in body:
		body.velocity += knockback_dir

# ==========================
# MORTE DO INIMIGO
# ==========================
func _die() -> void:
	if is_dead:
		return

	is_dead = true
	velocity = Vector2.ZERO

	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation(death_animation_name):
		sprite.play(death_animation_name)
		sprite.connect("animation_finished", Callable(self, "_on_die_animation_finished"))
	else:
		queue_free()

func _on_die_animation_finished() -> void:
	queue_free()
	
