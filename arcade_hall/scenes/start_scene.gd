extends Node2D

@onready var _camera = $Camera2D
@onready var _fade_in_black = $FadeInBlackShader
@onready var _press_start_text = $PressStartText

@export var _arcade_hall_scene: PackedScene
@export var _fade_time = 2.0

var _has_started: bool = false

func _process(_delta):
	if Input.is_action_just_pressed("space") and not _has_started:
		_has_started = true
		_start_game()
		
func _start_game():
	_camera.zoom_camera_to_point_with_transition(_fade_in_black, _load_arcade_hall_scene, _fade_time)

func _load_arcade_hall_scene():
	get_tree().change_scene_to_packed(_arcade_hall_scene)
	
