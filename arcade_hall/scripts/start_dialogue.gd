extends Sprite2D

@onready var text_box := $DialogueText
@onready var answer_box := $AnswersContainer
@onready var fem_dialogue := $FemaleDialogueBox
@onready var male_dialogue := $MaleDialogueBox
@onready var zoom_in_point = $ZoomInPoint
var fade_out_black 

@export var game_scene: PackedScene
var dialogue_dict: Dictionary
var answers_dict: Dictionary
var text_speed: float = 0.02
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
	
func step_dialogue_from_in_game():
	visible = true
	dialogue_step()
	
var input_lock = false
	
func _process(delta):
	if input_lock:
		return
	if visible == false:
		return
	if not is_loading_dialogue and Input.is_action_just_pressed("space"):
		if game_over_by_dialogue == true:
			display_failed_response()
		else:
			dialogue_step()
	if waiting_for_space and Input.is_action_just_pressed("space"):
		text_box.visible = false
		answer_box.visible = true
		waiting_for_space = false  # Reset the flag
		set_active_char("female_duck")
		is_waiting_for_answer = true
		var answers_id = dialogue_dict[current_dialogue_id]["answers"]
		current_right_answer_id = dialogue_dict[current_dialogue_id]["correct_answer"]
		var answers_array = get_answer_triples(answers_id)
		answer_box.set_answers(answers_array)
		
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
		
signal start_game_signal
signal dialogue_off_signal
		
func display_dialogue(dialogue_id: String) -> void:
	is_loading_dialogue = true
	if dialogue_dict[dialogue_id]["type"] == "breakpoint":
		if dialogue_dict[dialogue_id]["command"] == "start_arcade":
			fade_out_black = get_node("../FadeInWhite")
			var tween := get_tree().create_tween()
			tween.tween_property(fade_out_black, "color", Color(0,0,0,1), 2.0)
			await get_tree().create_timer(3.0).timeout
			get_tree().change_scene_to_packed(game_scene)
			return
		elif dialogue_dict[dialogue_id]["command"] == "start_game":
			start_game_signal.emit()
			visible = false
			is_loading_dialogue = false
		elif dialogue_dict[dialogue_id]["command"] == "dialogue_window_off":
			dialogue_off_signal.emit()
			visible = false
			is_loading_dialogue = false
		elif dialogue_dict[dialogue_id]["command"] == "win_game":
				input_lock = true
				game_over_by_dialogue_signal.emit(true)
			
	elif dialogue_dict[dialogue_id]["type"] == "question":
		is_loading_dialogue = true
		set_active_char(dialogue_dict[dialogue_id]["char"])
		current_fail_answer_response = dialogue_dict[dialogue_id]["failed_response"]
		text_box.clear()
		var dialogue_text = dialogue_dict[dialogue_id]["text"]
		for char in dialogue_text:
			text_box.add_text(char)
			await get_tree().create_timer(text_speed).timeout
		
		waiting_for_space = true

	else:
		is_loading_dialogue = true
		set_active_char(dialogue_dict[dialogue_id]["char"])
		text_box.clear()
		var dialogue_text = dialogue_dict[dialogue_id]["text"]
		for char in dialogue_text:
			text_box.add_text(char)
			await get_tree().create_timer(text_speed).timeout
		is_loading_dialogue = false
	
var waiting_for_space = false

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


func display_full_answer(full_answer):
	is_loading_dialogue = true
	text_box.clear()
	set_active_char("female_duck")
	
	for char in full_answer:
		text_box.add_text(char)
		await get_tree().create_timer(text_speed).timeout
		
	is_loading_dialogue = false


func display_failed_response():
	text_box.clear()
	set_active_char("male_duck")
	for char in current_fail_answer_response:
		text_box.add_text(char)
		await get_tree().create_timer(text_speed).timeout.connect(game_over)
		

signal game_over_by_dialogue_signal(has_won)
	
func game_over():
	input_lock = true
	await get_tree().create_timer(2).timeout
	game_over_by_dialogue_signal.emit(false)
	
	
		

