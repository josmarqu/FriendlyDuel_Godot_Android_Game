extends Node

var Pj1Score = 0
var Pj2Score = 0
const EndScreenScene = preload("res://scenes/PingPong/EndScreen.tscn")
export var MaxPoint = 11

	
func _on_TopWall_body_entered(body):
	pj_score()
	Pj2Score += 1

	
func _on_BottonWall_body_entered(body):
	pj_score()
	Pj1Score += 1


func go_to_end_screen():
	get_tree().change_scene_to(EndScreenScene)
	
	
func _process(delta):    
	$Pj1Score.text = str(Pj1Score)
	$Pj2Score.text = str(Pj2Score)
	$Countdown.text = str(int($BallTimer.time_left) + 1)
		
func pj_score():
	$Ball.position = Vector2(366, 599)
	get_tree().call_group('BallGroup', 'stop_ball')
	$BallTimer.start()
	$Countdown.visible = true
	$PointSound.play()
	$Player1.position.x = 438
	$Player2.position.x = 713

	if Pj1Score == MaxPoint or Pj2Score == MaxPoint:
		if Pj1Score == MaxPoint:
			GlobalAttributes.winner = str(1)
		else:
			GlobalAttributes.winner = str(2)
			
		go_to_end_screen()
	

func _on_BallTimer_timeout():
	get_tree().call_group('BallGroup','restart_ball')
	$Countdown.visible = false




