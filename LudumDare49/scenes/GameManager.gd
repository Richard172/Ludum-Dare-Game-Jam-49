extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):	
	if event.is_action_pressed("toggle_fullscreen"):
		if OS.window_fullscreen == true:
			OS.window_fullscreen = false;
		else:
			OS.window_fullscreen = true;
