extends Node
class_name DSLParser

func parse_dsl(text: String) -> Array:
	var regex = RegEx.new()
	regex.compile(r'(\w+)\s+"([^"]+)"\s*{([^}]*)}')
	var result := []
	
	for match in regex.search_all(text):
		var entity = match.get_string(1)
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

				# Checa se é inteiro
				var int_value = value.to_int()
				if str(int_value) == value:
					props[key] = int_value
				else:
					# Checa se é float
					var float_value = value.to_float()
					if str(float_value) == value:
						props[key] = float_value
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
