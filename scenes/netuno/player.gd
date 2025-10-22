extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var gravity_divider: float = 1

func _physics_process(delta: float) -> void:
	# Aplica gravidade
	if not is_on_floor():
		velocity += (get_gravity() * delta)/gravity_divider

	# Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * 1.15

	# Direção do movimento
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# --- Controle das animações ---
	if not is_on_floor():
		# No ar → animação de pulo
		if anim.animation != "pulando":
			anim.play("pulando")
	elif direction != 0:
		# Andando no chão
		if anim.animation != "andando":
			anim.play("andando")
	else:
		# Parado no chão
		if anim.animation != "ocioso":
			anim.play("ocioso")
