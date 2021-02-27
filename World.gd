extends Node

onready var darkness := $CanvasModulate
onready var blanche := $Blanche
onready var light := $Blanche/Light2D

func _unhandled_key_input(event):
	if event.is_action_pressed("Lights"):
		if darkness.is_visible_in_tree():
			darkness.hide()
			light.hide()
		else:
			darkness.show()
			light.show()
