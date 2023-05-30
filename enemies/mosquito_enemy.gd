extends CharacterBody2D

var direction = Vector2.ZERO
var speed = 24 * 6
var player
var spawn_cells
@onready var exit_screen_notifier = $VisibleOnScreenNotifier2D

func setup(player: Node2D, spawn_cells: Array[Vector2i]):
	self.player = player
	self.spawn_cells = spawn_cells
	get_node("VisibleOnScreenNotifier2D").screen_exited.connect(respawn)
	respawn()
	
func respawn():
	var random_cell = spawn_cells[randi() % spawn_cells.size()]
	global_position = random_cell * 24
	direction = get_direction_towards_player()


func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
	
func set_direction_towards_player():
	direction = get_direction_towards_player()
	

func get_direction_towards_player():
	if player != null:
		return global_position.direction_to(player.global_position)
	

signal on_queue_free_custom()

func queue_free_custom():
	on_queue_free_custom.emit()
	queue_free()

