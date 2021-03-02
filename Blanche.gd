extends KinematicBody2D

export var speed := 42
export var chit_chat_enabled := false setget _set_chit_chat_enabled
export var chit_chat_interval := 30.0

onready var animationPlayer := $AnimationPlayer
onready var chitChatTimer := $ChitChatTimer
onready var thoughtBubbleSpawner := $ThoughtBubbleSpawner

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

var sticky_direction

func think(text: String, duration: float = 3.0, urgent: bool = false) -> void:
	thoughtBubbleSpawner.show_bubble(text, duration, urgent)

func chit_chat(force: bool = false) -> void:
	if !chit_chat_enabled and !force:
		return

	var index = randi() % _idleChatter.size()
	chitChatTimer.start(chit_chat_interval)
	if thoughtBubbleSpawner.current_bubble == null or force:
		think(_idleChatter[index])

func clear_thoughts() -> void:
	thoughtBubbleSpawner.clear_bubbles()

func _physics_process(_delta: float) -> void:
	var velocity = Vector2.ZERO
	velocity.y -= Input.get_action_strength("Up") * speed
	velocity.y += Input.get_action_strength("Down") * speed
	velocity.x -= Input.get_action_strength("Left") * speed
	velocity.x += Input.get_action_strength("Right") * speed

	move_and_slide(velocity)

func _process(_delta: float) -> void:
	var idle = true
	if Input.is_action_pressed("Left"):
		animationPlayer.play("Left")
		idle = false
	if Input.is_action_pressed("Right"):
		animationPlayer.play("Right")
		idle = false
	if Input.is_action_pressed("Up"):
		animationPlayer.play("Up")
		idle = false
	if Input.is_action_pressed("Down"):
		animationPlayer.play("Down")
		idle = false

	if idle and sticky_direction != null and animationPlayer.has_animation(sticky_direction):
		animationPlayer.play(sticky_direction)

func _on_ChitChatTimer_timeout() -> void:
	chit_chat()

func _set_chit_chat_enabled(new_value: bool) -> void:
	chit_chat_enabled = new_value
	if new_value:
		chitChatTimer.start(chit_chat_interval)

