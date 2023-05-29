extends Node2D


@onready var enemy_spawner = $EnemySpawner
@onready var dialogue_box = $DialogueBox
@onready var press_start_text = $PressStartText
@onready var frog_player = $FrogPlayer

var enemy_kill_count = 0
var dialogue_kill_count_triggers = [3,6]
var is_start_dialogue_finished = false
var is_game_running = false
var is_dialogue_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_spawner.set_current_level("Level1")
	enemy_spawner.on_enemies_killed_changed.connect(incremenent_kill_count)
	get_window().set_content_scale_size(Vector2i(24*16,24*16))
	
	dialogue_box.start_game_signal.connect(set_start_dialogue_to_finished)
	
	# Shader stuff
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, 0,75,3).finished.connect(start_dialogue)
	
func incremenent_kill_count(count: int):
	if not is_dialogue_active:
		enemy_kill_count += count
		if enemy_kill_count in dialogue_kill_count_triggers:
			dialogue_box.visible = true
		
func _process(delta):
	if is_game_running:
		return
	if is_start_dialogue_finished and Input.is_action_just_pressed("item"):
		press_start_text.queue_free()
		start_game()
		is_game_running = true


func set_shader_value(value: int):
	$TransitionShader.material.set_shader_parameter("visible_rows", value)

func start_dialogue():
	$TransitionShader.queue_free()
	dialogue_box.visible = true
	
	
func start_game():
	frog_player.is_active = true
	spawn_enemies()
	
func spawn_enemies():
	enemy_spawner.spawn()
	enemy_spawner.spawn_mosquitos()
	enemy_spawner.spawn_bats()
	
func set_start_dialogue_to_finished():
	is_start_dialogue_finished = true
