tool
extends Node

onready var blanche := $Blanche
onready var light := $Blanche/Light2D

export var lights_on := false setget turn_lights_on

func _ready():
	# The lights_on export var is really only used to keep the lights on while
	# in the editor. This makes sure we start the game with the lights off.
	self.lights_on = false

func _unhandled_key_input(event):
	if event.is_action_pressed("Lights"):
		self.lights_on = !lights_on

func turn_lights_on(new_value: bool):
	lights_on = new_value

	if light:
		light.visible = !lights_on
