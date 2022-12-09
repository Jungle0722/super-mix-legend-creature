extends Node

func _init():
	pass

signal mouse_left
signal mouse_right

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("mouse_left")
		if event.button_index == BUTTON_RIGHT and event.pressed:
			emit_signal("mouse_right")