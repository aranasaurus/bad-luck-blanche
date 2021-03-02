extends KinematicBody2D

onready var bubbleSpawner := $ThoughtBubbleSpawner
onready var snoreTimer := $SnoreTimer

var is_sleeping = true

func _on_ThoughtBubbleSpawner_bubbles_finished() -> void:
	if is_sleeping:
		snoreTimer.start(20)

func _on_SnoreTimer_timeout() -> void:
	if is_sleeping:
		bubbleSpawner.show_bubble("...ZzzZzzzzzz...")
