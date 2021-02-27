extends KinematicBody2D

export var speed := 30

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	velocity.y -= Input.get_action_strength("ui_up") * speed
	velocity.y += Input.get_action_strength("ui_down") * speed
	velocity.x -= Input.get_action_strength("ui_left") * speed
	velocity.x += Input.get_action_strength("ui_right") * speed
	
	move_and_slide(velocity)
