extends KinematicBody2D

signal has_collided(collision)

export(float) var gravity: float = 200
onready var initial_gravity: float = gravity
export(float) var horizontal_speed: float = 100
export(float) var sudden_jump_speed: float = 150

var velocity: Vector2 = Vector2.ZERO
var initial_x
var initial_y

var jump: bool = true

func _ready():
	$Timer.set_wait_time(0.05)


func _physics_process(delta):
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("left"):
		velocity.x = -horizontal_speed
	elif Input.is_action_pressed("right"):
		velocity.x = horizontal_speed
	else:
		velocity.x = 0.0
	
	if gravity > 0:
		velocity = move_and_slide(velocity, Vector2.UP)
	else:
		velocity = move_and_slide(velocity, Vector2.DOWN)
	
	for i in get_slide_count():
		var has_collided = get_slide_collision(i)
		if has_collided:
			emit_signal('has_collided', has_collided)


func _timeout():
	if is_on_floor():
		if jump:
			if gravity > 0:
				velocity.y += -sudden_jump_speed
			else:
				velocity.y += sudden_jump_speed
			jump = false
		else:
			gravity = -gravity
			jump = true
	if velocity.y < 4 and velocity.y > 0:
		velocity.y = 0.1
