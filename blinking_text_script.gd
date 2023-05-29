extends Label

var tween: Tween

func _ready():
	start_blinking()

func start_blinking():
	blink_out()

func blink_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a",0,1.0).finished.connect(blink_in)
	
func blink_in():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a",1,1.0).finished.connect(blink_out)
	


