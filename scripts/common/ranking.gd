extends Control

@onready var player_names := [
	$player_name_container/player_name01,
	$player_name_container/player_name02,
	$player_name_container/player_name03,
	$player_name_container/player_name04,
	$player_name_container/player_name05
]

@onready var scores := [
	$score_container/score01,
	$score_container/score02,
	$score_container/score03,
	$score_container/score04,
	$score_container/score05
]

func _ready() -> void:
	var ranking = Globals.ranking_manager.load_ranking()
	var index := 0

	while index < 5:
		if index < ranking.size():
			player_names[index].text = ranking[index]["props"]["name"]
			scores[index].text = format_seconds_to_minutes(ranking[index]["props"]["score"])
		else:
			player_names[index].text = "?"
			scores[index].text = "?"
		index += 1

func format_seconds_to_minutes(seconds_value: Variant) -> String:
	var total_seconds := int(seconds_value)
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	return "%02d:%02d" % [minutes, seconds]

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file('res://screens/menu.tscn')
