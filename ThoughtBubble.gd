tool
extends Node2D

signal finished

export var current_text := "" setget _set_current_text
export var text_to_display := "" setget _set_text_to_display
export var display_duration := 3.0
export var per_letter_duration := 0.04

onready var label := $VBoxContainer/Label
onready var animationPlayer := $AnimationPlayer
onready var displayTimer := $DisplayTimer
onready var letterTimer := $LetterTimer

var _textLength := 0
var _textIndex := 0
var _finalText := ""

func _set_current_text(new_value: String) -> void:
	current_text = new_value
	if label:
		label.text = new_value

func _set_text_to_display(new_value: String) -> void:
	reset_text()
	_finalText = new_value
	_textLength = new_value.length()
	text_to_display = new_value

func _ready() -> void:
	if text_to_display != current_text:
		play_show_animation()

func show_text(text: String, duration: float) -> void:
	cancel_timers()
	reset_text()
	self.text_to_display = text
	display_duration = duration
	play_show_animation()

func play_show_animation():
	animationPlayer.play("Show")

func reset_text() -> void:
	self.current_text = ""
	_textIndex = 0
	_finalText = ""
	_textLength = 0

func cancel_timers() -> void:
	letterTimer.stop()
	displayTimer.stop()

func _advanceTextAnimation() -> void:
	if _textIndex >= _textLength:
		displayTimer.start(display_duration)
	else:
		self.current_text += _finalText[_textIndex]
		_textIndex += 1
		letterTimer.start(per_letter_duration)

func _on_Show_finished() -> void:
	letterTimer.start(per_letter_duration)

func _on_Hide_finished() -> void:
	reset_text()
	emit_signal("finished")

func _on_LetterTimer_timeout() -> void:
	_advanceTextAnimation()

func _on_DisplayTimer_timeout() -> void:
	animationPlayer.play("Hide")
