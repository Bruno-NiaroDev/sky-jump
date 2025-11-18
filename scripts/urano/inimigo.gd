extends CharacterBody2D


const SPEED = 2000.0
const JUMP_VELOCITY = -400.0

var direction := -1 
@onready var anim := $anim as AnimationPlayer
@onready var texture: Sprite2D = $texture
@onready var wall_detector: RayCast2D = $wall_detector
@onready var enemy_sfx: AudioStreamPlayer = $"../../sons/enemy_sfx"


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		
	if direction == 1:
		texture.flip_h = true
	else:
		texture.flip_h = false

	velocity.x = direction * SPEED * delta

	move_and_slide()

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'hurt':
		enemy_sfx.play()
		queue_free()
		await enemy_sfx.finished
		
		
	
