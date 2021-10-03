extends TileMap
signal sound_emitted

signal block_touched(tile_position)

onready var player
var pieces_number: int
var pieces_counter: int = 0 setget _increase_piece
var play_sound = true setget get_sound
var switch_once = true

export(float) var block_drop_time: float = 1

func get_sound(value):
	if value == false:
		emit_signal("sound_emitted")
	play_sound = value

func _ready():
	pieces_number = get_used_cells_by_id(5).size()
	connect("sound_emitted", self, "sound_cooldown")
	connect("block_touched", self, "_remove_block_start")

func _process(delta):
	pass

func _character_collided(collision):
	if collision.collider is TileMap:
		var tile_position = collision.collider.world_to_map(player.position)
		tile_position -= collision.normal
		var tile = collision.collider.get_cellv(tile_position)
		if tile == 2:
			$Death.play()
			get_tree().reload_current_scene()
		elif tile == 0:
			if play_sound:
				$Collide.play()
				self.play_sound = false
			emit_signal("block_touched", tile_position)
		elif tile == 3:
			if switch_once:
				$Switch.play()
				switch_once = false
			elif play_sound:
				$Collide.play()
				self.play_sound = false
			_remove_all_blocks()
		elif tile == 5:
			$Collect.play()
			self.pieces_counter += 1
			set_cellv(tile_position, -1)
		else:
			if play_sound:
				$Collide.play()
				self.play_sound = false


func _increase_piece(value):
	pieces_counter = value
	if pieces_counter == pieces_number:
		$DoorOpen.play()
		var cells = get_used_cells_by_id(6)
		for cell in cells:
			set_cellv(cell, -1)

func reset_player():
	player.position.x = player.initial_x
	player.position.y = player.initial_y
	player.velocity = Vector2.ZERO
	player.jump = true
	player.gravity = player.initial_gravity

func _remove_all_blocks():
	var cells = get_used_cells_by_id(4)
	for cell in cells:
		set_cellv(cell, 0)

func _remove_block_start(tile_position):
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(block_drop_time)
	timer.connect("timeout", self, "_remove_block", [tile_position, timer])
	timer.start()

func _remove_block(tile_position, timer):
	if play_sound:
		$Explode.play()
		self.play_sound = false
	timer.queue_free()
	set_cellv(tile_position, -1)

func sound_cooldown():
	$Timer.start()

func _on_Timer_timeout():
	play_sound = true
