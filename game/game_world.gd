extends Node2D


@onready var enemy_spawner = $EnemySpawner
@onready var dialogue_box = $DialogueBox

var dialogue_kill_count_triggers = [3,6]

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_spawner.set_current_level("Level1")
	enemy_spawner.spawn()
	enemy_spawner.on_enemies_killed_changed.connect(next_dialogue)
	get_window().set_content_scale_size(Vector2i(24*16,24*16))
	
func next_dialogue(number):
	if number in dialogue_kill_count_triggers:
		dialogue_box.foo()
	
