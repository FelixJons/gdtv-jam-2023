extends Node

@export var default_enemy_scene: PackedScene
@export var mosquito_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene
var current_level: TileMap
var horizontal_spawn_points
var vertical_spawn_points
var mosquito_spawn_points
var bat_spawn_points
const TILE_SIZE = 24
var player 
var astar_grid_node

const SpawnOrigin = {
	HORIZONTAL = 1,
	VERTICAL = 2,
	MOSQUITO = 3,
	BAT= 4
}

func _ready():
	player = get_node("../FrogPlayer")

func _process(delta):
	pass

func set_current_level(level_name: String):
	current_level = get_node("../" + level_name) as TileMap
	horizontal_spawn_points = current_level.get_used_cells_by_id(SpawnOrigin.HORIZONTAL)
	vertical_spawn_points = current_level.get_used_cells_by_id(SpawnOrigin.VERTICAL)
	mosquito_spawn_points = current_level.get_used_cells_by_id(SpawnOrigin.MOSQUITO)
	bat_spawn_points = current_level.get_used_cells_by_id(SpawnOrigin.BAT)
	
func spawn_default_vertical():
	for spawn_point in vertical_spawn_points:
		var enemy = default_enemy_scene.instantiate()
		enemy.setup(player)
		enemy.position = spawn_point * TILE_SIZE + Vector2i(TILE_SIZE/2, TILE_SIZE/2)
		add_child(enemy)
		enemy.on_queue_free_custom.connect(increment_enemies_killed_by_one)
	
func spawn_default_horizontal():
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
		
func spawn_bats():
	var enemy = bat_enemy_scene.instantiate()
	enemy.setup(player)
	var random_cell = bat_spawn_points[randi() % bat_spawn_points.size()]
	enemy.position = random_cell * TILE_SIZE + Vector2i(TILE_SIZE/2, TILE_SIZE/2)
	add_child(enemy)
	enemy.on_queue_free_custom.connect(increment_enemies_killed_by_one)
	

signal on_enemies_killed_changed(number_of_killed_enemies)

func increment_enemies_killed_by_one():
	on_enemies_killed_changed.emit(1)
