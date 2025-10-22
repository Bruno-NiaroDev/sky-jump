extends Node

# Importa managers e parser
const PlayerManager = preload("res://scripts/dsl/PlayerManager.gd")
const PlanetManager = preload("res://scripts/dsl/PlanetManager.gd")
const RankingManager = preload("res://scripts/dsl/RankingManager.gd")
const DSLParser = preload("res://scripts/dsl/DSLParser.gd")

var player_manager: PlayerManager
var planet_manager: PlanetManager
var ranking_manager: RankingManager

func _ready():
	print("=== Simulação de Jogo DSL ===")

	# Inicializa managers
	player_manager = PlayerManager.new()
	planet_manager = PlanetManager.new()
	ranking_manager = RankingManager.new()
	
	add_child(player_manager)
	add_child(planet_manager)
	add_child(ranking_manager)

	# 1️⃣ Cria novo jogador
	var player_name = "Bruno Rei"
	player_manager.create_player(player_name)
	print("\n👤 Novo jogador criado: %s" % player_name)

	# 2️⃣ Carrega planetas
	var planets = planet_manager.load_planets()
	if planets.size() == 0:
		printerr("Nenhum planeta encontrado em planets.txt!")
		return

	print("\n🪐 Planetas disponíveis:")
	for planet in planets:
		print("- %s | Gravidade: %.2f | Mínimo p/ avançar: %d"
			% [planet["name"], planet["props"]["gravity"], planet["props"]["minimum_to_be_collected"]])

	# 3️⃣ Simula progresso do jogador
	print("\n🎮 Progresso do jogador:")
	for i in range(min(3, planets.size())):
		var planet = planets[i]
		print("Entrando no nível %d: %s..." % [i + 1, planet["name"]])

		# Simula tempo e elementos extra coletados
		var new_duration = "00:0%d:1%d" % [i + 1, i + 2]
		var new_extras = (i + 1) * 5

		player_manager.update_player({
			"current_level": i + 1,
			"duration": new_duration,
			"extra_elements": new_extras,
			"lives": 3 - i
		})

		var player = player_manager.load_player()
		print("→ Concluído nível %d" % [player["props"]["current_level"]])
		print("   Tempo total: %s | Extras: %d | Vidas: %d"
			% [player["props"]["duration"], player["props"]["extra_elements"], player["props"]["lives"]])

	# 4️⃣ Calcula score final e adiciona ao ranking
	var player = player_manager.load_player()
	var score = int(player["props"]["current_level"]) * 330 + int(player["props"]["extra_elements"])
	print("\n🏁 Jogo concluído! Score final de %s: %d pontos" % [player_name, score])

	ranking_manager.add_score(player_name, score)

	# 5️⃣ Exibe ranking atualizado
	var ranking = ranking_manager.load_ranking()
	print("\n🏆 Ranking Atual:")
	for entry in ranking:
		print("%sº - %s: %d pontos"
			% [entry["name"], entry["props"]["name"], entry["props"]["score"]])

	# 6️⃣ Reseta player para novo jogo
	player_manager.reset_player()
	print("\n♻️ Player resetado. Pronto para novo jogo!")

	print("\n=== Fim da Simulação ===")
