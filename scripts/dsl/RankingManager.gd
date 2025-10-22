extends Node
class_name RankingManager

@export var file_path := "res://config/ranking.txt"
var parser: DSLParser

func _ready():
	parser = DSLParser.new()

func load_ranking() -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("Arquivo de ranking não encontrado, retornando lista vazia")
		return []
	var content = file.get_as_text()
	file.close()
	
	var ranking = parser.parse_dsl(content)
	# Converte scores para int
	for entry in ranking:
		if entry["props"].has("score"):
			entry["props"]["score"] = int(entry["props"]["score"])
	return ranking

func add_score(name: String, score: int) -> void:
	score = int(score)
	var ranking = load_ranking()

	# Ignora se tiver 5 e score <= 5º
	if ranking.size() >= 5 and score <= int(ranking[4]["props"]["score"]):
		print("Score %d de %s não entrou no ranking (menor que o 5º)" % [score, name])
		return

	# Cria nova entrada
	var new_entry = {
		"type": "RANKED",
		"name": "",
		"props": {"name": name, "score": score}
	}

	# Insere na posição correta manualmente
	_insert_score(ranking, new_entry)

	# Mantém apenas top 5
	if ranking.size() > 5:
		ranking = ranking.slice(0, 5)

	# Atualiza posições
	for i in range(ranking.size()):
		ranking[i]["name"] = str(i + 1)

	# Salva no arquivo
	_save(ranking)
	print("Ranking atualizado com sucesso!")

# Função recursiva de inserção decrescente
func _insert_score(ranking: Array, entry: Dictionary, index: int = 0) -> void:
	if index >= ranking.size():
		ranking.append(entry)
		return
	if entry["props"]["score"] > ranking[index]["props"]["score"]:
		ranking.insert(index, entry)
		return
	_insert_score(ranking, entry, index + 1)

# Salva no arquivo
func _save(data: Array) -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		printerr("Não foi possível abrir arquivo para salvar ranking: %s" % file_path)
		return
	file.store_string(parser.serialize_dsl(data))
	file.close()
