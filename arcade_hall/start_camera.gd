extends Camera2D

var zoom_in_point: Node2D
var lerp_speed = 1.0
@onready var fade_out_black := get_node("../FadeOutBlack")
@export var arcade_scene: PackedScene
var tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()
	zoom_in_point = $ZoomInPoint

var has_started = false

func _process(delta):
	if has_started and not tween.is_running():
		get_tree().change_scene_to_packed(arcade_scene)
	if Input.is_action_just_pressed("item") and not has_started:
		start_game()
		has_started = true

func start_game():
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "zoom", Vector2(3,3), 5)
	tween.tween_property(self, "global_position", zoom_in_point.global_position, 5)
	tween.chain().tween_property(fade_out_black, "color", Color(0,0,0,1), 2.0)
	
	
