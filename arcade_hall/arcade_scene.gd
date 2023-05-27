extends Node2D

@onready var fade_out_white := get_node("FadeInWhite")
# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().set_content_scale_size(Vector2i(400,304))
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out_white, "color", Color(1,1,1,1), 2.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
