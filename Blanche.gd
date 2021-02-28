extends KinematicBody2D

export var speed := 42

onready var animationPlayer := $AnimationPlayer
onready var bubble := find_node("ThoughtBubble")
onready var thoughtTimer := $ThoughtTimer

func _physics_process(_delta: float) -> void:
	var velocity = Vector2.ZERO
	velocity.y -= Input.get_action_strength("ui_up") * speed
	velocity.y += Input.get_action_strength("ui_down") * speed
	velocity.x -= Input.get_action_strength("ui_left") * speed
	velocity.x += Input.get_action_strength("ui_right") * speed

	move_and_slide(velocity)

func _process(_delta: float) -> void:
	var moving = false
	if Input.is_action_pressed("ui_left"):
		animationPlayer.play("Left")
		moving = true
	if Input.is_action_pressed("ui_right"):
		animationPlayer.play("Right")
		moving = true
	if Input.is_action_pressed("ui_up"):
		animationPlayer.play("Up")
		moving = true

	if Input.is_action_pressed("ui_down") or not moving:
		animationPlayer.play("Down")

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action("Say"):
		bubble.show()
		bubble.text = "Sure is dark in here."

