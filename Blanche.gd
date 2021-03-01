extends KinematicBody2D

const ThoughtBubble = preload("res://ThoughtBubble.tscn")

export var speed := 42
export var bubble_offset := Vector2(19, -19)
export var chit_chat_enabled := false setget _set_chit_chat_enabled
export var chit_chat_interval := 30.0

onready var animationPlayer := $AnimationPlayer
onready var chitChatTimer := $ChitChatTimer

var _idleChatter := PoolStringArray([
	"I seem to have lost some pep from my step.",
	"Where's the clicker?",
	"It's cold in here. Are you cold?",
	"I feel so light and airy!",
	"Ugh, these ad-breaks will be the death of me.",
	"Where'd I leave that remote?",
	"\"Thank you for being a frieeeeennnd\"",
	"\"Traveled down the road and back agaaaain\"",
	"\"Your heart is true, you're a friend and a confidaaaant\""
])

var current_bubble: Node
var bubbles := []

func think(text: String, duration: float = 3.0, urgent: bool = false) -> void:
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

func clear_thoughts() -> void:
	for bubble in bubbles:
		bubble.queue_free()
	bubbles.clear()
	if current_bubble:
		remove_child(current_bubble)
		current_bubble.queue_free()
		current_bubble = null

func chit_chat(force: bool = false) -> void:
	if !chit_chat_enabled and !force:
		return

	var index = randi() % _idleChatter.size()
	chitChatTimer.start(chit_chat_interval)
	if current_bubble == null or force:
		think(_idleChatter[index])

func _physics_process(_delta: float) -> void:
	var velocity = Vector2.ZERO
	velocity.y -= Input.get_action_strength("Up") * speed
	velocity.y += Input.get_action_strength("Down") * speed
	velocity.x -= Input.get_action_strength("Left") * speed
	velocity.x += Input.get_action_strength("Right") * speed

	move_and_slide(velocity)

func _process(_delta: float) -> void:
	var moving = false
	if Input.is_action_pressed("Left"):
		animationPlayer.play("Left")
		moving = true
	if Input.is_action_pressed("Right"):
		animationPlayer.play("Right")
		moving = true
	if Input.is_action_pressed("Up"):
		animationPlayer.play("Up")
		moving = true

	if Input.is_action_pressed("Down") or not moving:
		animationPlayer.play("Down")

func _on_ChitChatTimer_timeout() -> void:
	chit_chat()

func _on_ThoughtBubble_finished() -> void:
	remove_child(current_bubble)
	current_bubble.queue_free()

	current_bubble = bubbles.pop_front()
	if current_bubble:
		add_child(current_bubble)

func _set_chit_chat_enabled(new_value: bool) -> void:
	chit_chat_enabled = new_value
	if new_value:
		chitChatTimer.start(chit_chat_interval)

func _make_bubble() -> Node:
	var bubble := ThoughtBubble.instance()
	bubble.position = bubble_offset
	bubble.connect("finished", self, "_on_ThoughtBubble_finished")
	return bubble
