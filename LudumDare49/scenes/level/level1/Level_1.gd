extends Node2D

onready var player = $Player
var player_x = 56
var player_y = 56
onready var tilemap = $TileMap

func _ready():
	player.connect("has_collided", self, "_character_collided")
	player.initial_x = player_x
	player.initial_y = player_y
	player.position.x = player.initial_x
	player.position.y = player.initial_y

func _character_collided(collision):
	if collision.collider is TileMap:
		var tile_position = collision.collider.world_to_map($Player.position)
		tile_position -= collision.normal
		var tile = collision.collider.get_cellv(tile_position)
		if tile == 1:
			get_tree().reload_current_scene()

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
