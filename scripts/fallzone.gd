extends Area2D
@onready var lava_sfx: AudioStreamPlayer = $lava_sfx


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.handle_death_zone()
	lava_sfx.play()
