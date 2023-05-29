extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().set_content_scale_size(Vector2i(400,240))
	
	if WinLoseSingleton.won_the_game:
		$BlinkingText.text = "You won! <3"
	else:
		$BlinkingText.text = "You lost! </3"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
