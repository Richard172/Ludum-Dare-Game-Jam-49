class_name Platform
extends KinematicBody2D

onready var tween = get_node("Tween")

var can_move: bool = true
var to_move_dir: bool = true
export var tiles: int = 8
export var move_name: String = "right"
export var time: int = 1
const tile_size = 16
var moves: = {
	"right": Vector2(1.0, 0.0),
	"left": Vector2(-1.0, 0.0),
	"up": Vector2(0.0, -1.0),
	"down": Vector2(0.0, 1.0)
}
var init_x: float
var init_y: float

func _ready():
	init_x = position.x
	init_y = position.y

func _process(delta):
	if can_move:
		move(move_name)

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

func _on_Tween_tween_all_completed():
	can_move = true
