extends Node2D

@export var game_over_scene: PackedScene

var won_the_game: bool = false

func lose_the_game():
	won_the_game = false
	get_tree().change_scene_to_packed(game_over_scene)

