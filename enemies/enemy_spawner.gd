extends Node

@export var default_enemy_scene: PackedScene
@export var mosquito_enemy_scene: PackedScene
var current_level: TileMap
var horizontal_spawn_points
var mosquito_spawn_points
const TILE_SIZE = 24
var player 
var astar_grid_node

var enemies_killed = 0

const SpawnOrigin = {
	HORIZONTAL = 1,
	VERTICAL = 2,
	MOSQUITO = 3
	
}

func _ready():
	player = get_node("../FrogPlayer")

func _process(delta):
	pass

func set_current_level(level_name: String):
	current_level = get_node("../" + level_name) as TileMap
	horizontal_spawn_points = current_level.get_used_cells_by_id(SpawnOrigin.HORIZONTAL)
	mosquito_spawn_points = current_level.get_used_cells_by_id(SpawnOrigin.MOSQUITO)

func spawn():
	for spawn_point in horizontal_spawn_points:
		var enemy = default_enemy_scene.instantiate()
		enemy.setup(player)
		enemy.position = spawn_point * TILE_SIZE + Vector2i(TILE_SIZE/2, TILE_SIZE/2)
		add_child(enemy)
		enemy.on_queue_free_custom.connect(increment_enemies_killed_by_one)


func spawn_mosquitos():
	var enemy = mosquito_enemy_scene.instantiate()
	enemy.setup(player, mosquito_spawn_points)
	add_child(enemy)
	enemy.on_queue_free_custom.connect(increment_enemies_killed_by_one)
		
	

signal on_enemies_killed_changed(number_of_killed_enemies)

func increment_enemies_killed_by_one():
	enemies_killed += 1
	on_enemies_killed_changed.emit(enemies_killed)
