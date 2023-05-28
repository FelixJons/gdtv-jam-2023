extends Sprite2D

@onready var text_box := $DialogueTextLabel
@onready var fem_dialogue := $FemaleDialogueBox
@onready var male_dialogue := $MaleDialogueBox
@export var game_scene: PackedScene
var dialogue_dict: Dictionary
var text_speed: float = 0.05
var answer_delay: float = 1.0
var is_loading_dialogue = false
var current_dialogue_id = "001"
# Called when the node enters the scene tree for the first time.
func _ready():
	fem_dialogue.visible = false
	male_dialogue.visible = false
	
	dialogue_dict = Dialogue.start_dialogue_dict
	
	# First dialogue step
	display_dialogue(current_dialogue_id)
	
func _process(delta):
	if not is_loading_dialogue and Input.is_action_just_pressed("item"):
		current_dialogue_id = increment_string_number_by_one(current_dialogue_id)
		display_dialogue(current_dialogue_id)

func set_active_char(char: String) -> void:
	if char == "female_duck":
		fem_dialogue.visible = true
		male_dialogue.visible = false
	elif char == "male_duck":
		fem_dialogue.visible = false
		male_dialogue.visible = true
		
func display_dialogue(dialogue_id: String) -> void:
	if dialogue_dict[dialogue_id]["type"] == "breakpoint":
		get_tree().change_scene_to_packed(game_scene)
		return
		
	elif dialogue_dict[dialogue_id]["type"] == "question":
		is_loading_dialogue = true
		set_active_char(dialogue_dict[dialogue_id]["char"])
		text_box.clear()
		var dialogue_text = dialogue_dict[dialogue_id]["text"]
		for char in dialogue_text:
			text_box.add_text(char)
			await get_tree().create_timer(text_speed).timeout
		await get_tree().create_timer(answer_delay).timeout

	else:
		is_loading_dialogue = true
		set_active_char(dialogue_dict[dialogue_id]["char"])
		text_box.clear()
		var dialogue_text = dialogue_dict[dialogue_id]["text"]
		for char in dialogue_text:
			text_box.add_text(char)
			await get_tree().create_timer(text_speed).timeout
		is_loading_dialogue = false
	
func increment_string_number_by_one(s: String) -> String:
	var number = int(s) # convert the string to int
	number += 1 # increment the number
	return str(number).pad_zeros(3) # convert back to string and return
