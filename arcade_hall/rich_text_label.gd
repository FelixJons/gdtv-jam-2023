extends RichTextLabel

var id: String
var short_answer: String
var full_answer: String

func _ready():
	clear()
	
	self.meta_clicked.connect(_on_meta_clicked)
	self.meta_hover_started.connect(_on_meta_hover_entered)
	self.meta_hover_ended.connect(_on_meta_hover_exited)

func _on_meta_hover_entered(meta):
	clear()
	push_color(Color.YELLOW)
	append_text("[url=" + str(id) + "]" + str(short_answer) + "[/url]")
	pop()

func _on_meta_hover_exited(meta):
	clear()
	append_text("[url=" + str(id) + "]" + str(short_answer) + "[/url]")
	pop()

signal answer_choosen(id: String, full_answer: String)

func _on_meta_clicked(meta):
	answer_choosen.emit(id, full_answer)
	
	
func set_answer_text(answer_id, short_answer, full_answer):
	self.id = answer_id
	self.short_answer = short_answer
	self.full_answer = full_answer
	clear()
	append_text("[url=" + str(id) + "]" + str(short_answer) + "[/url]")
