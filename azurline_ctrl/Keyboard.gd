extends Node

func _init():
	pass

signal key_w
signal key_a
signal key_s
signal key_d
signal key_q
signal key_e
signal key_r
signal key_t
signal key_z
signal key_x
signal key_c
signal key_v
signal key_h
signal key_i
signal key_j
signal key_k
signal key_l
signal key_space

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_W: emit_signal("key_w")
			KEY_A: emit_signal("key_a")
			KEY_S: emit_signal("key_s")
			KEY_D: emit_signal("key_d")
			KEY_Q: emit_signal("key_q")
			KEY_E: emit_signal("key_e")
			KEY_R: emit_signal("key_r")
			KEY_T: emit_signal("key_t")
			KEY_Z: emit_signal("key_z")
			KEY_X: emit_signal("key_x")
			KEY_C: emit_signal("key_c")
			KEY_V: emit_signal("key_v")
			KEY_H: emit_signal("key_h")
			KEY_I: emit_signal("key_i")
			KEY_J: emit_signal("key_j")
			KEY_K: emit_signal("key_k")
			KEY_L: emit_signal("key_l")
			KEY_SPACE: emit_signal("key_space")