class_name Level
extends Node2D

onready var player = $Player
onready var tilemap = $TileMap
export(int) var player_x: int
export(int) var player_y: int

func _ready():
	tilemap.player = player
	player.connect("has_collided", tilemap, "_character_collided")
	player.initial_x = player_x
	player.initial_y = player_y
	player.position.x = player.initial_x
	player.position.y = player.initial_y

func _process(delta):
	pass

func reset_player():
	player.position.x = player.initial_x
	player.position.y = player.initial_y
	player.velocity = Vector2.ZERO
	player.jump = true
	player.gravity = player.initial_gravity

func _enter_next_level():
	get_tree().change_scene("res://scenes/level/level2/level2.tscn")

func _on_WinningArea_area_entered(area):
	_enter_next_level()
