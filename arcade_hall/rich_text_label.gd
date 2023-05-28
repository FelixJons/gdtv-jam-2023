extends RichTextLabel

var answer_id: String

func _ready():
	clear()
	
	answer_id = "answer_id"
	append_text("[url=" + str(answer_id) + "]Hi[/url]")
	
	self.meta_clicked.connect(_on_meta_clicked)
	self.meta_hover_started.connect(_on_meta_hover_entered)
	self.meta_hover_ended.connect(_on_meta_hover_exited)

func _on_meta_hover_entered(meta):
	clear()
	push_color(Color.YELLOW)
	append_text("[url=" + str(answer_id) + "]Hi[/url]")
	pop()

func _on_meta_hover_exited(meta):
	clear()
	append_text("[url=" + str(answer_id) + "]Hi[/url]")
	pop()

func _on_meta_clicked(meta):
	print("Clicked on text with meta: " + meta)
