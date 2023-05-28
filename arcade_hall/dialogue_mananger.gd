extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	var resource = load("res://test_dialogue.dialogue")
	var dialogue_line = await resource.get_next_dialogue_line("start")
	$DialogueLabel.dialogue_line(dialogue_line)
	$DialogueLabel.type_out()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
