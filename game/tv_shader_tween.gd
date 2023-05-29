extends ColorRect

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, 0.0, 1.0, 2)
	
func set_shader_value(value: float):
	material.set_shader_parameter("progress", value)
	
