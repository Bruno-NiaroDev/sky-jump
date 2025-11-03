extends Node

# Configuação dos levels
var selected_planet := ""
var block_levels := ["urano", "saturno", "jupiter", "marte", "terra"]


var elements := 0
var player_life := 3

var player = null
var current_checkpoint = null
var player_start_position = null


func respawn_player():
	if current_checkpoint!= null:
		player.position = current_checkpoint.global_position
	else:
		player.global_position = player_start_position.global_position
