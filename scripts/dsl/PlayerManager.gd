extends Node
class_name PlayerManager

@export var file_path := "res://config/player.txt"
var parser = DSLParser.new()

func create_player(name: String) -> Dictionary:
	var player = {
		"type": "PLAYER",
		"name": name,
		"props": {
			"current_level": 1,
			"duration": "00:00:00",
			"extra_elements": 0,
			"lives": 3
		}
	}
	_save([player])
	return player

func load_player() -> Dictionary:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		printerr("Arquivo de player não encontrado: %s" % file_path)
		return {}
	var content = file.get_as_text()
	file.close()
	return parser.parse_dsl(content)[0]

func update_player(updates: Dictionary) -> void:
	var player = load_player()
	var props = player["props"]

	for key in updates.keys():

		if key in ["duration", "extra_elements"]:
			var new_value = int(updates[key])
			var current_value = int(props.get(key, 0))
			props[key] = current_value + new_value
		else:
			props[key] = updates[key]

	_save([player])

func reset_player() -> void:
	var player = load_player()
	player["props"] = {
		"current_level": 1,
		"duration": "00:00:00",
		"extra_elements": 0,
		"lives": 3
	}
	_save([player])

func _save(data: Array) -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(parser.serialize_dsl(data))
	file.close()
