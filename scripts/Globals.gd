extends Node

const PlayerManager = preload("res://scripts/dsl/PlayerManager.gd")
const PlanetManager = preload("res://scripts/dsl/PlanetManager.gd")
const RankingManager = preload("res://scripts/dsl/RankingManager.gd")
const DSLParser = preload("res://scripts/dsl/DSLParser.gd")

var player_manager = PlayerManager.new()
var planet_manager = PlanetManager.new()
var ranking_manager = RankingManager.new()

# Configuação dos levels
var selected_planet := ""
var block_levels = []
var planetas := {}
var total_seconds_level := 0

var planets = planet_manager.load_planets()

var elements := 0
var player_life := 3

var player = null
var current_checkpoint = null
var player_start_position = null
var is_ranked = true

func _ready() -> void:
	for planet in planets:
		var name = planet["name"].to_lower()
		var props = planet["props"]
		# aqui copiamos TODAS as propriedades do planeta
		planetas[name] = props.duplicate()
		
		if planet["name"].to_lower() != "netuno":
			block_levels.append(planet["name"].to_lower())

func reset_level():
	elements = 0
	player_life = 3
	player = null
	current_checkpoint = null
	player_start_position = null


func respawn_player():
	if current_checkpoint!= null:
		player.position = current_checkpoint.global_position
	else:
		player.global_position = player_start_position.global_position

func save_level():
	print("Salvando Level: " + selected_planet)
	var new_duration = total_seconds_level
	var new_extras = elements - planetas[selected_planet]["minimum_to_be_collected"]
	player_manager.update_player({
		"duration": new_duration,
		"extra_elements": new_extras,
		"lives": 3
	})
	
	if selected_planet == "marte":
		var player = player_manager.load_player()
		var score = int(player["props"]["duration"]) - (int(player["props"]["extra_elements"]) * 3)
		Globals.ranking_manager.add_score(player["props"]["name"], score)
