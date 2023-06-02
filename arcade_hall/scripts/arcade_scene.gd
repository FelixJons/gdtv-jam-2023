extends Node2D

@onready var fade_out_black = $FadeOutBlackShader
@onready var fade_inblack = $FadeInBlackShader

func _ready():
	get_window().set_content_scale_size(Vector2i(400,304))
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out_black, "color", Color(1,1,1,1), 2.0).finished.connect(start_dialogue)
	
func start_dialogue():
	pass

