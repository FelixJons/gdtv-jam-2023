extends Node

var start_dialogue_file_path = "res://dialogue_data/start_dialogue.json"
var answer_dialogue_file_path = "res://dialogue_data/start_dialogue.json"
var start_dialogue_dict: Dictionary
var answer_dialogue_dict: Dictionary

func _ready():
	start_dialogue_dict = load_json_dialogue(start_dialogue_file_path)
	answer_dialogue_dict = load_json_dialogue(answer_dialogue_file_path)

func load_json_dialogue(file_path) -> Dictionary:
	var json_as_dict
	if FileAccess.file_exists(file_path):
		var json_as_text = FileAccess.get_file_as_string(file_path)
		json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict
