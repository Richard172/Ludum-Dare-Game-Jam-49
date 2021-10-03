class_name Spike
extends Node2D

onready var tween = get_node("Tween")

var can_move: bool = true
var to_move_dir: bool = true
export var tiles: int = 8
export var move_name: String = "right"
export var time: int = 1
export var move_flag_num: int = 1
const tile_size = 16
var moves: = {
	"right": Vector2(1.0, 0.0),
	"left": Vector2(-1.0, 0.0),
	"up": Vector2(0.0, -1.0),
	"down": Vector2(0.0, 1.0)
}
var init_x: float
var init_y: float
export(float) var total_time: float = 2
export(float) var x_radius: float = 100
export(float) var y_radius: float = 200

func _ready():
	init_x = position.x
	init_y = position.y

func _process(delta):
	if move_flag_num == 1:
		if can_move:
			move(move_name)
	elif move_flag_num == 2:
		position.x = sin(total_time) * x_radius + init_x
		position.y = cos(total_time) * y_radius + init_y
		total_time += delta
		

func reset_player(player):
	player.position.x = player.initial_x
	player.position.y = player.initial_y
	player.velocity = Vector2.ZERO
	player.jump = true
	player.gravity = player.initial_gravity

func move(direction):
	can_move = false
	var from
	var to
	if to_move_dir:
		from = position
		to = position + moves[direction] * tiles * tile_size
		to_move_dir = false
	else:
		from = position 
		to = position - moves[direction] * tiles * tile_size
		to_move_dir = true
		
	tween.interpolate_property(self, "position", from, to, time, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func player_entered(area):
	var player = area.get_parent()
	get_tree().reload_current_scene()

func _on_Tween_tween_all_completed():
	can_move = true
