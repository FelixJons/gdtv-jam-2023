extends BoxContainer

@export var answer_label_1: RichTextLabel
@export var answer_label_2: RichTextLabel
@export var answer_label_3: RichTextLabel
var answer_list

# Called when the node enters the scene tree for the first time.
func _ready():
	answer_list = [answer_label_1, answer_label_2, answer_label_3]
	for answer in answer_list:
		answer.answer_choosen.connect(on_answer_chosen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_answers(answers: Array) -> void:
	for i in range(len(answers)):
		answer_list[i].set_answer_text(answers[i][0], answers[i][1], answers[i][2]) 
	
signal answer_signal(id: String, full_answer: String)

func on_answer_chosen(id, full_answer):
	answer_signal.emit(id, full_answer)
	

