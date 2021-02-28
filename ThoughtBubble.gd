tool
extends Node2D

export var text := "" setget set_text, get_text
export var displayDuration := 3

onready var label := $VBoxContainer/Label
onready var animationPlayer := $AnimationPlayer
onready var displayTimer := $DisplayTimer


func get_text() -> String:
	if label:
		return label.text
	else:
		return ""

func set_text(new_value: String) -> void:
	if label:
		label.text = new_value

func show() -> void:
	animationPlayer.play("Show")

func _on_Show_finished() -> void:
	displayTimer.start(displayDuration)

func _on_Timer_timeout() -> void:
	animationPlayer.play("Hide")
