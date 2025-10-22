extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

# DECLARAÇÃO DOS DETECTORES
@onready var wall_detector := $wal_detectot as RayCast2D
@onready var wall_detector2 := $wal_detectot2 as RayCast2D # <--- NOVO
@onready var texture := $texture as Sprite2D	

var direction:= -1 # -1 para esquerda, 1 para direita

# O seu script define 'gravity' como um int, assumimos que é o valor escalar da gravidade.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# NOTA IMPORTANTE:
# Certifique-se de que no editor do Godot, o nó 'wal_detectot' aponte para a esquerda 
# e o nó 'wal_detectot2' aponte para a direita.

func _physics_process(delta: float) -> void:
	# 1. Aplicar a gravidade.
	if not is_on_floor():
		# Aplica a gravidade apenas no eixo Y
		velocity.y += gravity * delta
	
	# 2. Detecção de Parede e Inversão de Direção
	# Se um dos detectores (o esquerdo OU o direito) estiver colidindo, inverte a direção.
	if wall_detector.is_colliding() or wall_detector2.is_colliding():
		direction *= -1 # Inverte a direção
		
	# 3. Inverter a Textura (Flipar)
	if direction == 1:
		texture.flip_h = true # Vira a textura para a direita
	else:
		texture.flip_h = false # Vira a textura para a esquerda
	
	# 4. Aplicar a Velocidade X
	# A velocidade deve ser em pixels/segundo (não use 'delta' aqui).
	velocity.x = direction * SPEED

	# 5. Movimentação
	move_and_slide()
