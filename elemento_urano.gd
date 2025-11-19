extends Area2D
@onready var coin_sfx: AudioStreamPlayer = $"../../sons/coin_sfx"


var elements := 1

func _on_body_entered(body: Node2D) -> void:
	Globals.elements += elements
	coin_sfx.play()
	queue_free()
	await coin_sfx.finished	
