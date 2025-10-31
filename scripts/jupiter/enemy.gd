extends CharacterBody2D

const SPEED = 50.0    
const GRAVITY = 1800.0 

var direction := -1    # -1 = esquerda, 1 = direita

@onready var wall_left := $wall_left as RayCast2D
@onready var wall_right := $wall_right as RayCast2D
@onready var texture := $texture as Sprite2D
@onready var anim := $anim as AnimationPlayer

func _ready() -> void:
	# garanta que os RayCasts estão ativos
	if wall_left:
		wall_left.enabled = true
	if wall_right:
		wall_right.enabled = true

func _physics_process(delta: float) -> void:
	# Gravidade (aplica no eixo y)
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		# se quiser "zerar" o pulo quando no chão:
		velocity.y = 0

	# Lógica de troca de direção usando os dois RayCasts
	# Se estiver indo para a direita e detectar parede à direita, vira
	if direction == 1 and wall_right.is_colliding():
		direction = -1
	# Se estiver indo para a esquerda e detectar parede à esquerda, vira
	elif direction == -1 and wall_left.is_colliding():
		direction = 1

	# Atualiza o sprite (flip)
	texture.flip_h = direction == 1

	# Movimento horizontal (IMPORTANTE: velocity.x em px/s, sem multiplicar por delta)
	velocity.x = direction * SPEED

	# Move o personagem (CharacterBody2D.move_and_slide atualiza internamente)
	move_and_slide()

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		queue_free()
