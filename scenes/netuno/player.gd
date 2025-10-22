extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var gravity_divider: float = 1

var can_double_jump := false  # Controle do pulo duplo

func _physics_process(delta: float) -> void:
	# Aplica gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY * 1.15
			can_double_jump = true  # Permite o pulo duplo após sair do chão
		elif can_double_jump:
			velocity.y = JUMP_VELOCITY * 1.15
			can_double_jump = false  # Pulo duplo usado

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
