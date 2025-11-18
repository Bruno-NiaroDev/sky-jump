extends CharacterBody2D

const SPEED = 200.0
const JUMP_FORCE = -400.0

var is_jumping := false
var is_hurted := false
var knockback_vector := Vector2.ZERO
var direction
var can_double_jump := false  # controle do pulo duplo

@onready var animation:= $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var ray_right := $ray_right as RayCast2D
@onready var ray_left := $ray_left as RayCast2D
@onready var jump_sfx := $jump_sfx as AudioStreamPlayer 

signal player_has_died()

func _physics_process(delta: float) -> void:
	# --- Gravidade ---
	if not is_on_floor():
		velocity += get_gravity() * delta

	# --- Pulo e Pulo Duplo ---
	if Input.is_action_just_pressed("move_up"):
		if is_on_floor():
			velocity.y = JUMP_FORCE
			is_jumping = true
			jump_sfx.play()               # SOM DO PRIMEIRO PULO
			can_double_jump = true        # permite pulo duplo

		elif can_double_jump:
			velocity.y = JUMP_FORCE
			jump_sfx.play()               # SOM DO PULO DUPLO
			can_double_jump = false       # gastou o pulo duplo

	elif is_on_floor():
		is_jumping = false
		can_double_jump = false          # reseta no chão

	# --- Movimento Horizontal ---
	direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("ocioso")

	# --- Knockback ---
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	_set_state()
	move_and_slide()
	
	# --- Detecção de colisões com plataformas ---
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)


# --- DETECÇÃO DE DANO ---
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if ray_right.is_colliding():
		take_damage(Vector2(-200, -200))
	elif ray_left.is_colliding():
		take_damage(Vector2(200, -200))
		
# --- SEGUIR CÂMERA ---
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

# --- MECÂNICA DE DANO E VIDA ---
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal("player_has_died")
		await player_has_died 

	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false

# --- DEFINIÇÃO DO ESTADO / ANIMAÇÃO ---
func _set_state():
	var state = "ocioso"
	
	if !is_on_floor():
		state = "pulando"
	elif direction != 0:
		state = "andando"
		
	#if is_hurted:
	#	state = "hurt"	
	
	if animation.name != state:
		animation.play(state)

# --- COLISÃO COM OBJETOS (CABEÇA) ---
func _on_head_collider_body_entered(body: Node2D) -> void:
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 1:
			body.break_sprite()
		else:
			body.animation_player.play("hit")
			body.create_coin()

# --- ZONA DE MORTE ---
func handle_death_zone():
	if Globals.player_life > 0:
		Globals.player_life -= 1
		visible = false
		set_physics_process(false)
		await get_tree().create_timer(1.0).timeout
		Globals.respawn_player()
		visible = true
		set_physics_process(true)
	else:
		emit_signal("player_has_died")
