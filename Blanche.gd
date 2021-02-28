extends KinematicBody2D

export var speed := 42

onready var animationPlayer := $AnimationPlayer
onready var bubble := find_node("ThoughtBubble")
onready var thoughtTimer := $ThoughtTimer

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

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action("Help"):
		bubble.show_text("Sure is dark in here.")

