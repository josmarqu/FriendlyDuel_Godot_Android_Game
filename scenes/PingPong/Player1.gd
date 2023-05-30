extends KinematicBody2D

var speed = 400

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity.x -= 600
	elif Input.is_action_pressed("ui_down"):
		velocity.x += 600
	move_and_slide(velocity)
	
	



