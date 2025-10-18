extends CharacterBody2D

@export var SPEED: float = 30.0
@onready var wall_detector: RayCast2D = $wall_detector

var direction: int = 1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = direction * SPEED

	if wall_detector.is_colliding():
		print("Colidiu com parede!") # 🪲 debug
		direction *= -1
		scale.x *= -1
		wall_detector.position.x *= -1

	move_and_slide()
