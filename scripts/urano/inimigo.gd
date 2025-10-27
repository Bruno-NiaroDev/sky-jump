extends Node2D

const SPEED = 60

var direction = 1

@onready var ray_cast_rigth = $RayCastRigthUrano
@onready var ray_cast_left = $RayCastLeftUrano
@onready var animated_srite = $InimigoUrano

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_rigth.is_colliding():
		direction = -1
		animated_srite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_srite.flip_h = false
		
	position.x += direction * SPEED * delta
