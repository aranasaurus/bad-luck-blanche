tool
extends Node2D

export var currentText := "" setget _set_currentText
export var displayDuration := 3
export var perLetterDuration := 0.04

onready var label := $VBoxContainer/Label
onready var animationPlayer := $AnimationPlayer
onready var displayTimer := $DisplayTimer
onready var letterTimer := $LetterTimer

var _textLength := 0
var _textIndex := 0
var _finalText := ""

func _set_currentText(new_value: String) -> void:
	currentText = new_value
	if label:
		label.text = new_value

func show_text(text: String) -> void:
	cancel_timers()
	reset_text()
	_finalText = text
	_textLength = text.length()

	animationPlayer.play("Show")

func reset_text() -> void:
	self.currentText = ""
	_textIndex = 0
	_finalText = ""
	_textLength = 0

func cancel_timers() -> void:
	letterTimer.stop()
	displayTimer.stop()

func _advanceTextAnimation() -> void:
	if _textIndex >= _textLength:
		displayTimer.start(displayDuration)
	else:
		self.currentText += _finalText[_textIndex]
		_textIndex += 1
		letterTimer.start(perLetterDuration)

func _on_Show_finished() -> void:
	letterTimer.start(perLetterDuration)

func _on_Hide_finished() -> void:
	reset_text()

func _on_LetterTimer_timeout() -> void:
	_advanceTextAnimation()

func _on_DisplayTimer_timeout() -> void:
	animationPlayer.play("Hide")
