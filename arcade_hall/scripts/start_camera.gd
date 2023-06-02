extends Camera2D

@onready var zoom_in_point = $ZoomInPoint

func zoom_camera_to_point_with_transition(shader: CanvasModulate, zoom_finished_callback: Callable, fade_time: float):
	print()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "zoom", Vector2(3,3), 5)
	tween.tween_property(self, "global_position", zoom_in_point.global_position, 5)
	tween.chain().tween_property(shader, "color", Color(0,0,0,1), fade_time)
	tween.tween_callback(zoom_finished_callback)
	
	
