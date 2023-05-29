extends Node2D

@onready var enemy_spawner = $EnemySpawner
@onready var dialogue_box = $DialogueBox
@onready var press_start_text = $PressStartText
@onready var frog_player = $FrogPlayer
@export var game_over_scene: PackedScene

@onready var default_vertical_timer = $DefaultVerticalTimer
@onready var default_horizontal_timer = $DefaultHorizontalTimer
@onready var mosquito_timer = $MosquitoTimer
@onready var bat_timer = $BatTimer

var enemy_kill_count = 0
var dialogue_kill_count_triggers = [10,20,30]
var is_start_dialogue_finished = false
var is_game_running = false
var is_dialogue_active = false
var phase_id = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_spawner.set_current_level("Level1")
	enemy_spawner.on_enemies_killed_changed.connect(incremenent_kill_count)
	get_window().set_content_scale_size(Vector2i(24*16,24*16))
	
	
	frog_player.frog_died_signal.connect(on_frog_died)
	dialogue_box.start_game_signal.connect(set_start_dialogue_to_finished)
	dialogue_box.dialogue_off_signal.connect(enable_kill_count)
	dialogue_box.game_over_by_dialogue_signal.connect(game_over_tween)
	# Shader stuff
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, 0,75,3).finished.connect(start_dialogue)
	
func on_frog_died():
	game_over_tween(false)

func incremenent_kill_count(count: int):
	if not is_dialogue_active:
		enemy_kill_count += count
		print(enemy_kill_count)
		if enemy_kill_count in dialogue_kill_count_triggers:
			dialogue_box.step_dialogue_from_in_game()
			is_dialogue_active = true
		
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
	default_vertical_timer.start()
	default_horizontal_timer.start()
	default_vertical_timer.wait_time = 7.0
	default_horizontal_timer.wait_time = 5.0
	default_vertical_timer.timeout.connect(enemy_spawner.spawn_default_vertical)
	default_horizontal_timer.timeout.connect(enemy_spawner.spawn_default_horizontal)
	
func set_start_dialogue_to_finished():
	is_start_dialogue_finished = true

func enable_kill_count():
	phase_id += 1
	if phase_id == 1:
		bat_timer.start()
		bat_timer.wait_time = 6.0
		bat_timer.timeout.connect(enemy_spawner.spawn_bats)
	elif phase_id == 2:
		mosquito_timer.start()
		mosquito_timer.wait_time = 5.0
		mosquito_timer.timeout.connect(enemy_spawner.spawn_mosquitos)
	else:
		print("Game ova")
		game_over_tween(true)
	is_dialogue_active = false
	
func game_over_tween(player_has_won):
	WinLoseSingleton.won_the_game = player_has_won
	var tween = get_tree().create_tween()
	$GameOverShader.z_index = 100
	tween.tween_property($GameOverShader.material, "shader_parameter/progress", 1.0, 4).finished.connect(switch_to_game_over)
	
func switch_to_game_over():
	get_tree().change_scene_to_packed(game_over_scene)

