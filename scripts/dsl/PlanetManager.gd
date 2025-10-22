extends Node
class_name PlanetManager

@export var file_path := "res://config/planets.txt"
var parser: DSLParser

func _ready():
	parser = DSLParser.new()

func load_planets() -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		printerr("Arquivo de planetas não encontrado!")
		return []
	var content = file.get_as_text()
	file.close()
	return parser.parse_dsl(content)
