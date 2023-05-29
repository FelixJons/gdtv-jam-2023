extends Sprite2D

@onready var text_box := $DialogueText
@onready var answer_box := $AnswersContainer
@onready var fem_dialogue := $FemaleDialogueBox
@onready var male_dialogue := $MaleDialogueBox
@export var game_scene: PackedScene
var dialogue_dict: Dictionary
var answers_dict: Dictionary
var text_speed: float = 0.05
var answer_delay: float = 1.0
var is_loading_dialogue = false
var current_dialogue_id = "001"
var current_right_answer_id: String
var is_waiting_for_answer = false
var current_fail_answer_response: String

@export var is_in_game: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	fem_dialogue.visible = false
	male_dialogue.visible = false
	
	dialogue_dict = Dialogue.start_dialogue_dict if not is_in_game else Dialogue.in_game_dialogue_dict
	answers_dict = Dialogue.answer_dialogue_dict
	answer_box.answer_signal.connect(answer_recieved)
	# First dialogue step
	display_dialogue(current_dialogue_id)
	
func _process(delta):
	if not is_loading_dialogue and Input.is_action_just_pressed("item"):
		if game_over_by_dialogue == true:
			display_failed_response()
		else:
			dialogue_step()

func dialogue_step():
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
		current_fail_answer_response = dialogue_dict[dialogue_id]["failed_response"]
		text_box.clear()
		var dialogue_text = dialogue_dict[dialogue_id]["text"]
		for char in dialogue_text:
			text_box.add_text(char)
			await get_tree().create_timer(text_speed).timeout
		await get_tree().create_timer(answer_delay).timeout
		
		set_active_char("female_duck")
		is_waiting_for_answer = true
		var answers_id = dialogue_dict[dialogue_id]["answers"]
		current_right_answer_id = dialogue_dict[dialogue_id]["correct_answer"]
		
		var answers_array = get_answer_triples(answers_id)
		answer_box.set_answers(answers_array)
		text_box.visible = false
		answer_box.visible = true

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

func get_answer_triples(answer_ids):
	var triples = []
	for answer_id in answer_ids:
		if answer_id in answers_dict.keys():
			var short_text = answers_dict[answer_id]["short_text"]
			var full_text = answers_dict[answer_id]["text"]
			triples.append([answer_id, short_text, full_text])
	return triples

var game_over_by_dialogue = false

func answer_recieved(id: String, full_answer):
	is_waiting_for_answer = false
	answer_box.visible = false
	text_box.visible = true
	display_full_answer(full_answer)
	
	if id == current_right_answer_id or current_right_answer_id == "all":
		game_over_by_dialogue = false
	else:
		game_over_by_dialogue = true
	
	is_loading_dialogue = false


func display_full_answer(full_answer):
	text_box.clear()
	set_active_char("female_duck")
	
	for char in full_answer:
		text_box.add_text(char)
		await get_tree().create_timer(text_speed).timeout


func display_failed_response():
	text_box.clear()
	set_active_char("male_duck")
	for char in current_fail_answer_response:
		text_box.add_text(char)
		await get_tree().create_timer(text_speed).timeout

