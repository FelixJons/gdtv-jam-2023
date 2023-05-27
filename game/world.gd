extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawner.set_current_level("Level1")
	$EnemySpawner.spawn()
	get_window().set_content_scale_size(Vector2i(24*16,24*16))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
