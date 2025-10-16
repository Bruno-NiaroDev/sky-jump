extends CharacterBody2D

var grav = 800       # Força da gravidade
var speed = 200      # Velocidade de movimento
var jump_force = -400 # Força do pulo (negativo para cima)

func _physics_process(delta):
	# --- 1. Gravidade ---
	if not is_on_floor():
		velocity.y += grav * delta
	else:
		# Pulo Normal (Utiliza a sua ação "jump" - W, Up, ou Space)
		if Input.is_action_just_pressed("jump"): 
			velocity.y = jump_force

	# --- 2. Movimento Lateral ---
	# Utiliza as suas ações "move_right" e "move_left"
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
		# Vira o AnimatedSprite2D para a direita
		$AnimatedSprite2D.flip_h = false 
		$AnimatedSprite2D.play("andando") # toca animação de andar
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
		# Vira o AnimatedSprite2D para a esquerda
		$AnimatedSprite2D.flip_h = true 
		$AnimatedSprite2D.play("andando") # toca animação de andar
	else:
		velocity.x = 0
		$AnimatedSprite2D.play("parado") # toca animação de parado
	
	# --- 3. Pulo Extra (Opcional) ---
	# Removido o pulo extra original (ui_up) pois a sua ação "jump"
	# já inclui a tecla "Up" e "W". Manter a lógica do pulo dentro do 'else'
	# é a prática mais comum para evitar pulos acidentais ou duplos.
	# Se você quiser que o pulo seja *muito* mais forte ao tocar no chão,
	# você pode reintroduzir uma lógica separada aqui, mas geralmente a seção
	# acima já resolve o pulo.

	# --- 4. Aplica Movimento ---
	move_and_slide()
