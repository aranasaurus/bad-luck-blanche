extends KinematicBody2D

export var speed := 30

onready var animationPlayer := $AnimationPlayer

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
