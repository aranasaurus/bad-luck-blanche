tool
extends Node

onready var blanche := $Blanche
onready var maskLight := $Blanche/Light2D
onready var ambientLight := $AmbientLight
onready var intro_timer := $IntroTimer
onready var tv := $Table/TV

export var lights_on := false setget turn_lights_on

var _darknessHints := PoolStringArray([
	"Sure is dark in here.",
	"Who turned out the [L]ights?"
])

var _recentlyDisplayedHints := {
	"darkness": PoolStringArray()
}

var _introStep = 0
var _introComplete = false
var _hasTurnedLightsOnBefore = false
var _inRangeOfTV = false

func _ready():
	# The lights_on export var is really only used to keep the lights on while
	# in the editor. This makes sure we start the game with the lights off.
	self.lights_on = false
	blanche.sticky_direction = "Down"
	randomize()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Lights"):
		self.lights_on = !lights_on

	if Input.is_action_just_pressed("Help"):
		var hint = get_hint()
		if hint:
			blanche.think(hint, 3.0, true)
		else:
			blanche.chit_chat()

	if Input.is_action_just_pressed("Chat"):
		blanche.chit_chat(true)

	if Input.is_action_just_pressed("TV"):
		interact_with_tv()

func interact_with_tv():
	if _inRangeOfTV:
		blanche.think("I can't make the knobs work in this incorporeal form!", 4.0, true)
	else:
		blanche.think("The TV's way over there, I can't touch it from here!", 4.0, true)

func turn_lights_on(new_value: bool):
	lights_on = new_value
	if !_hasTurnedLightsOnBefore and lights_on:
		_hasTurnedLightsOnBefore = true
		intro_timer.stop()
		blanche.clear_thoughts()

		blanche.think("!!! I'm a ghost?!", 2.5, true)
		blanche.think("Where'd my body go?! I've got a series finale to watch!")
		blanche.chit_chat_enabled = true

	if maskLight:
		maskLight.visible = !lights_on

	if ambientLight:
		ambientLight.visible = lights_on

func get_hint():
	if !lights_on:
		if _darknessHints.empty():
			_darknessHints = _recentlyDisplayedHints["darkness"]
			_recentlyDisplayedHints["darkness"] = PoolStringArray([])
		else:
			var hint = _darknessHints[0]
			_darknessHints.remove(0)
			var recent = _recentlyDisplayedHints["darkness"]
			recent.append(hint)
			_recentlyDisplayedHints["darkness"] = recent
			return hint

	return null

func get_next_hint(type: String):
	match type:
		"darkness":
			if _darknessHints.empty():
				_darknessHints = _recentlyDisplayedHints[type]
				_recentlyDisplayedHints[type] = PoolStringArray([])
			else:
				var hint = _darknessHints[0]
				_darknessHints.remove(0)
				var recent = _recentlyDisplayedHints["darkness"]
				recent.append(hint)
				_recentlyDisplayedHints["darkness"] = recent
				return hint

	return null

var _introHelpMessage1 = "[H]mmm. What a pickle I've found myself in."
var _introHelpMessage2 = "[H]ow am I going to see the ending of that finale?!"
var _introHelpMessage = 1
func _on_IntroTimer_timeout() -> void:
	if _introComplete:
		if _introHelpMessage == 1:
			blanche.think(_introHelpMessage1)
			_introHelpMessage = 2
		else:
			blanche.think(_introHelpMessage2)
			_introHelpMessage = 1

		if !_hasTurnedLightsOnBefore:
			intro_timer.start(15)
	else:
		blanche.think("What happened? Where's my 'Girls!?\nI'm gonna miss the ending!!", 2.5, true)
		blanche.think("The ad-break will surely be over soon!", 3)
		blanche.think("I need to get my buns in front of a [T]elevision, pronto!", 3.5)
		_introComplete = true
		intro_timer.start(23)

	blanche.chit_chat_enabled = _hasTurnedLightsOnBefore

func _on_InteractionArea_body_entered(_body: Node) -> void:
	_inRangeOfTV = true
	blanche.sticky_direction = "Up"

func _on_InteractionArea_body_exited(_body: Node) -> void:
	_inRangeOfTV = false
	blanche.sticky_direction = "Down"
