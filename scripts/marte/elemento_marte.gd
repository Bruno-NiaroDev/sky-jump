extends Area2D

@onready var anim := $AnimatedSprite2D
@onready var collision := $CollisionShape2D

var elemento_valor := 1  # quanto esse item vale

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	# Evita a colisão dupla de moeda
	queue_free()
	await collision.call_deferred("queue_free")
	Globals.elements += elemento_valor
