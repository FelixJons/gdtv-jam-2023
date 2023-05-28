extends Node

class_name DialogueManager

func _ready():
	load_dialogue(2)

func load_dialogue(file_path) -> Dictionary:
	file_path = "res://dialogue_data/start_dialogue.json"
	if FileAccess.file_exists(file_path):
		var json_as_text = FileAccess.get_file_as_string(file_path)
		var json_as_dict = JSON.parse_string(json_as_text)
		if json_as_dict:
			print(json_as_dict)
			print(json_as_dict["001"]["text"])
	return Dictionary()


"""var json_as_text = FileAccess.get_file_as_string(file)
var json_as_dict = JSON.parse_string(json_as_text)
if json_as_dict:
	print(json_as_dict)"""
