tool
extends Node2D
class_name ThoughtBubble

export var text := "" setget set_text, get_text

onready var label := $VBoxContainer/Label


func get_text() -> String:
	if label:
		return label.text
	else:
		return ""

func set_text(new_value: String) -> void:
	if label:
		label.text = new_value

func say(text: String, node: Node2D) -> void:
	node.add_child(self)
	self.text = text
	position = Vector2(12, -8)
