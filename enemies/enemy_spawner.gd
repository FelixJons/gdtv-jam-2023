extends Node

@export var default_enemy_scene: PackedScene
var current_level: TileMap
var horizontal_spawn_points
const TILE_SIZE = 24
var player 
var astar_grid_node

const SpawnOrigin = {
	HORIZONTAL = 1,
	VERTICAL = 2
}

func _ready():
	player = get_node("../FrogPlayer")

func _process(delta):
	pass

func set_current_level(level_name: String):
	current_level = get_node("../" + level_name) as TileMap
	horizontal_spawn_points = current_level.get_used_cells_by_id(SpawnOrigin.HORIZONTAL)

func spawn():
	for spawn_point in horizontal_spawn_points:
		var enemy = default_enemy_scene.instantiate()
		enemy.setup(player)
		enemy.position = spawn_point * TILE_SIZE + Vector2i(TILE_SIZE/2, TILE_SIZE/2)
		add_child(enemy)

