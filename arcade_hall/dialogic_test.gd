extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_dialog = Dialogic.start('test_timeline')
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
