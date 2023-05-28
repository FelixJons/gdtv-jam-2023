extends Node

var start_dialogue_file_path = "res://dialogue_data/start_dialogue.json"
var start_dialogue_dict: Dictionary

func _ready():
	start_dialogue_dict = load_dialogue(start_dialogue_file_path)

func load_dialogue(file_path) -> Dictionary:
	var json_as_dict
	if FileAccess.file_exists(file_path):
		var json_as_text = FileAccess.get_file_as_string(file_path)
		json_as_dict = JSON.parse_string(json_as_text)
		if json_as_dict:
			print(json_as_dict)
			print(json_as_dict["001"]["text"])
	return json_as_dict

func start_dialogue() -> Array:
	var char = start_dialogue_dict["001"]["char"]
	var text = start_dialogue_dict["001"]["text"]
	return [char,text]
