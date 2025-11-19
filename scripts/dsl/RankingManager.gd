extends Node
class_name RankingManager

@export var file_path := "res://config/ranking.txt"

func load_ranking() -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("Arquivo de ranking não encontrado, retornando lista vazia")
		return []
	var content = file.get_as_text()
	file.close()
	
	var ranking = DslParser.parse_dsl(content)
	
	# Garante score como inteiro
	for entry in ranking:
		if entry["props"].has("score"):
			entry["props"]["score"] = int(entry["props"]["score"])
	
	return ranking

func add_score(name: String, score: int) -> void:
	score = int(score)
	var ranking = load_ranking()

	if ranking.size() >= 5 and score >= int(ranking[4]["props"]["score"]):
		print("Score %d de %s não entrou (pior que o 5º)" % [score, name])
		return

	var new_entry = {
		"type": "RANKED",
		"name": "",
		"props": {"name": name, "score": score}
	}

	_insert_score(ranking, new_entry)

	if ranking.size() > 5:
		ranking = ranking.slice(0, 5)

	for i in range(ranking.size()):
		ranking[i]["name"] = str(i + 1)

	_save(ranking)
	print("Ranking atualizado com sucesso!")

func _insert_score(ranking: Array, entry: Dictionary, index: int = 0) -> void:
	if index >= ranking.size():
		ranking.append(entry)
		return

	if entry["props"]["score"] < ranking[index]["props"]["score"]:
		ranking.insert(index, entry)
		return

	_insert_score(ranking, entry, index + 1)

func _save(data: Array) -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		printerr("Não foi possível abrir o arquivo: %s" % file_path)
		return
	file.store_string(DslParser.serialize_dsl(data))
	file.close()
