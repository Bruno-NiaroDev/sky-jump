extends CharacterBody2D

const SPEED = 3000.0

var direction := -1 
@onready var wall_detector := $wall_detector as RayCast2D
@onready var texture := $texture as Sprite2D
@onready var anim := $anim as AnimationPlayer
@export var enemy_score := 100
@onready var sfx_enemy_dead: AudioStreamPlayer = $"../../sons/sfx_enemy_dead"


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1

	texture.flip_h = (direction == 1)

	velocity.x = direction * SPEED * delta
	move_and_slide()


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		
		# TOCA SOM GLOBAL
		var sfx = get_tree().current_scene.get_node("sfx_enemy_dead")
		sfx_enemy_dead.play(0.2)

		# DESAPARECE IMEDIATAMENTE
		queue_free()
		await sfx_enemy_dead.finished
	
