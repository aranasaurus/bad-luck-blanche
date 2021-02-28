tool
extends Node

onready var blanche := $Blanche
onready var light := $Blanche/Light2D
onready var intro_timer := $IntroTimer

export var lights_on := false setget turn_lights_on

var _darknessHints := PoolStringArray([
	"Sure is dark in here.",
	"Who turned out the [L]ights?"
])

var _defaultHints := PoolStringArray([
	"I feel sluggish"
])

var _recentlyDisplayedHints := {
	"darkness": PoolStringArray(),
	"default": PoolStringArray()
}

var _introStep = 0
var _freeHintsIntroStep = 3

func _ready():
	# The lights_on export var is really only used to keep the lights on while
	# in the editor. This makes sure we start the game with the lights off.
	self.lights_on = false
	randomize()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Lights"):
		self.lights_on = !lights_on
	if Input.is_action_just_pressed("Help"):
		blanche.think(get_hint())
		if _introStep == _freeHintsIntroStep:
			intro_timer.stop()

func turn_lights_on(new_value: bool):
	lights_on = new_value

	if light:
		light.visible = !lights_on

func get_hint() -> String:
	if !lights_on:
		return get_next_hint("darkness")
	else:
		return get_next_hint("default")

func get_next_hint(type: String) -> String:
	match type:
		"darkness":
			if !_darknessHints.empty():
				var hint = _darknessHints[0]
				_darknessHints.remove(0)
				var recent = _recentlyDisplayedHints["darkness"]
				recent.append(hint)
				_recentlyDisplayedHints["darkness"] = recent
				return hint

	# Handle the "default" case.
	if _defaultHints.empty():
		# Default hints have all been shown. Refill it.
		var recentHints := Array(_recentlyDisplayedHints["default"] as PoolStringArray)
		recentHints.shuffle()
		_defaultHints = PoolStringArray(recentHints)
		_recentlyDisplayedHints["default"] = PoolStringArray([])

		# if we were asked for a non-default hint, and the default hints was empty,
		# Reset the original type as well.
		match type:
			"darkness":
				_darknessHints = _recentlyDisplayedHints[type]
				_recentlyDisplayedHints[type] = PoolStringArray([])

		# With everything reset we can try again and shouldn't enter this path again.
		return get_next_hint(type)
	else:
		var hint = _defaultHints[0]
		_defaultHints.remove(0)
		var recent = _recentlyDisplayedHints["default"]
		recent.append(hint)
		_recentlyDisplayedHints["default"] = recent
		return hint


func _on_IntroTimer_timeout() -> void:
	match _introStep:
		0:
			_introStep += 1
			blanche.think("What happened? Where's my Girls!?!!")
			intro_timer.start(6)
		1:
			_introStep += 1
			blanche.think("The ad-break will surely be over soon!")
			intro_timer.start(6)
		2:
			_introStep += 1
			blanche.think("I need to get my buns to a TV, pronto!")
			intro_timer.start(16)
		_freeHintsIntroStep:
			blanche.think(get_hint())
			intro_timer.start(30)

