extends Node2D
class_name ThoughtBubbleSpawner, "res://sprites/thought_bubble_trail.png"

const ThoughtBubble = preload("res://ThoughtBubble.tscn")

var current_bubble: Node
var bubbles := []

func show_bubble(text: String, duration: float = 3.0, urgent: bool = false) -> void:
	if urgent:
		if !current_bubble:
			current_bubble = _make_bubble()
			add_child(current_bubble)

		current_bubble.show_text(text, duration)
	else:
		var bubble := _make_bubble()
		bubble.text_to_display = text
		bubble.display_duration = duration

		if !current_bubble:
			current_bubble = bubble
			add_child(current_bubble)
		else:
			bubbles.append(bubble)

func clear_bubbles() -> void:
	for bubble in bubbles:
		bubble.queue_free()
	bubbles.clear()
	if current_bubble:
		remove_child(current_bubble)
		current_bubble.queue_free()
		current_bubble = null

func _make_bubble() -> Node:
	var bubble := ThoughtBubble.instance()
	bubble.connect("finished", self, "_on_ThoughtBubble_finished")
	return bubble

func _on_ThoughtBubble_finished() -> void:
	remove_child(current_bubble)
	current_bubble.queue_free()

	current_bubble = bubbles.pop_front()
	if current_bubble:
		add_child(current_bubble)
