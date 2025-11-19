extends Node
class_name PlanetManager

@export var file_path := "res://config/planets.txt"

func load_planets() -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		printerr("Arquivo de planetas não encontrado!")
		return []
	var content = file.get_as_text()
	file.close()
	return DslParser.parse_dsl(content)
