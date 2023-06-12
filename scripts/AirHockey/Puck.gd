extends RigidBody2D

func _integrate_forces(state):
	if state.linear_velocity.length() > 2000:
		state.linear_velocity *= 2000 / state.linear_velocity.length()

func _on_Puck_body_entered(_body):
	$ImpactSound.play()
