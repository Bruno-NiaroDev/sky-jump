extends Node
class_name DSLParser

const VALID_TYPES := ["LEVEL", "PLAYER", "RANKED"]

func parse_dsl(text: String) -> Array:
	var regex = RegEx.new()
	regex.compile(r'(\w+)\s+"([^"]+)"\s*{([^}]*)}')
	var result := []
	
	for match in regex.search_all(text):
		var entity = match.get_string(1)

		# ⚠️ Validação do tipo
		if not VALID_TYPES.has(entity):
			show_corruption_screen()
			return []

		var name = match.get_string(2)
		var body = match.get_string(3)
		
		var props := {}
		for line in body.strip_edges().split("\n"):
			line = line.strip_edges()
			if line == "":
				continue
			if ":" in line:
				var parts = line.split(":", false, 2)
				var key = parts[0].strip_edges()
				var value = parts[1].strip_edges().rstrip(",")

				if value.is_valid_int():
					props[key] = int(value)
				elif value.is_valid_float():
					props[key] = float(value)
				elif value.begins_with('"') and value.ends_with('"'):
					props[key] = value.substr(1, value.length() - 2)
				else:
					props[key] = value

		result.append({
			"type": entity,
			"name": name,
			"props": props
		})
	return result


func serialize_dsl(data: Array) -> String:
	var output := ""
	for item in data:
		output += "%s \"%s\" {\n" % [item["type"], item["name"]]
		for key in item["props"].keys():
			var value = item["props"][key]
			if typeof(value) == TYPE_STRING:
				value = "\"%s\"" % value
			output += "  %s: %s,\n" % [key, str(value)]
		output += "}\n\n"
	return output.strip_edges()

func show_corruption_screen() -> void:
	print("DSL inválida! Arquivo corrompido.")
	# Garante que o nó já está na tree antes de trocar a cena
	call_deferred("_go_to_error")
	

func _go_to_error() -> void:
	get_tree().change_scene_to_file("res://screens/error_corrupted_game.tscn")
