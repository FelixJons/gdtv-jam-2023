extends Node2D


@onready var enemy_spawner = $EnemySpawner
@onready var dialogue_box = $DialogueBox
@onready var press_start_text = $PressStartText

var dialogue_kill_count_triggers = [3,6]
var is_start_dialogue_finished = true
var is_game_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_spawner.set_current_level("Level1")
	enemy_spawner.on_enemies_killed_changed.connect(next_dialogue)
	get_window().set_content_scale_size(Vector2i(24*16,24*16))
	
	# Shader stuff
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, 0,75,3).finished.connect(start_dialogue)
	
func _process(delta):
	if is_game_running:
		return
	if is_start_dialogue_finished and Input.is_action_just_pressed("item"):
		press_start_text.queue_free()
		spawn_enemies()
		is_game_running = true


func set_shader_value(value: int):
	$TransitionShader.material.set_shader_parameter("visible_rows", value)

func next_dialogue(number):
	if number in dialogue_kill_count_triggers:
		dialogue_box.foo()
	
func start_dialogue():
	print("Dialogue started")
	
func spawn_enemies():
	enemy_spawner.spawn()
	enemy_spawner.spawn_mosquitos()
	enemy_spawner.spawn_bats()
