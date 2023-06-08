extends Node2D

const LAP_TARGET: int = 3
const CAR_ACCELERATION: float = 0.001
const CAR_DECELERATION: float = 0.00025
const CAR_MAX_SPEED: float = 0.005
const CAR_DERAIL_SPEED: float = 0.004

onready var audio_game_lap = get_node("AudioStreamLap")
onready var audio_game_crash = get_node("AudioStreamCrash")
onready var audio_player1 = get_node("AudioStreamPlayer1")
onready var audio_player2 = get_node("AudioStreamPlayer2")
onready var blue_car = get_node("Player1Path2D/Player1PathFollow2D")
onready var green_car = get_node("Player2Path2D/Player2PathFollow2D")
onready var blue_car_animation = get_node("Player1Path2D/Player1PathFollow2D/Player1Area2D/BlueCar/AnimationPlayer1")
onready var green_car_animation = get_node("Player2Path2D/Player2PathFollow2D/Player2Area2D/GreenCar/AnimationPlayer2")
export var blue_car_speed: float = 0
export var green_car_speed: float = 0
export var blue_car_laps: int = 0
export var green_car_laps: int = 0
var blue_car_prev_offset: float = 0
var green_car_prev_offset: float = 0
var blue_car_running: bool = false
var green_car_running: bool = false
var lap_finished_audio = load("res://audio/lap_finished.mp3")
var car_running_audio = load("res://audio/car_running.mp3")
var car_crash_audio = load("res://audio/car_crash.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_game_lap.stream = lap_finished_audio
	audio_game_lap.stream.loop = false
	audio_game_crash.stream = car_crash_audio
	audio_game_crash.stream.loop = false
	audio_player1.stream = car_running_audio
	audio_player2.stream = car_running_audio

func accelerate(player: String):
	if player == "Player1" and blue_car_speed <= CAR_MAX_SPEED:
		blue_car_speed += CAR_ACCELERATION
		audio_player1.playing = true
	elif player == "Player2" and green_car_speed <= CAR_MAX_SPEED:
		green_car_speed += CAR_ACCELERATION
		audio_player2.playing = true

func stop_accelerate(player: String):
	if player == "Player1":
		if blue_car_speed > 0:
			blue_car_speed -= CAR_DECELERATION
		else:
			blue_car_speed = 0
			audio_player1.playing = false
	elif player == "Player2":
		if green_car_speed > 0:
			green_car_speed -= CAR_DECELERATION
		else:
			green_car_speed = 0
			audio_player2.playing = false

func stop_car(player: String):
	if player == "Player1":
		blue_car_speed = 0
		blue_car_running = false
	elif player == "Player2":
		green_car_speed = 0
		green_car_running = false

func run_car(player: String):
	if player == "Player1":
		blue_car_running = true
	elif player == "Player2":
		green_car_running = true

func car_in_curve(player: String, pos: String):
	if player == "Player1":
		if blue_car_speed > CAR_DERAIL_SPEED:
			audio_game_crash.play()
			stop_car("Player1")
			if pos == "Right":
				blue_car_animation.play("DerailRight")
			elif pos == "Left":
				blue_car_animation.play("DerailLeft")

	if player == "Player2":
		if green_car_speed > CAR_DERAIL_SPEED:
			audio_game_crash.play()
			stop_car("Player2")
			if pos == "Right":
				green_car_animation.play("DerailRight")
			elif pos == "Left":
				green_car_animation.play("DerailLeft")

# Called every frame
func _physics_process(_delta):
	if blue_car_running:
		var blue_car_result = update_car(blue_car, blue_car_speed, blue_car_prev_offset, blue_car_laps)
		blue_car_prev_offset = blue_car_result[0]
		blue_car_laps = blue_car_result[1]
	if green_car_running:
		var green_car_result = update_car(green_car, green_car_speed, green_car_prev_offset, green_car_laps)
		green_car_prev_offset = green_car_result[0]
		green_car_laps = green_car_result[1]
	if blue_car_laps == LAP_TARGET or green_car_laps == LAP_TARGET:
		blue_car_running = false
		green_car_running = false
		if blue_car_laps == LAP_TARGET:
			print("Player 1 Win")
		elif green_car_laps == LAP_TARGET:
			print("Player 2 Win")
		set_process(false)

func update_car(car, car_speed: float, prev_offset: float, car_laps: int):
	var current_offset = car.unit_offset
	car.unit_offset += car_speed
	if current_offset < prev_offset:
		car_laps += 1
		audio_game_lap.play()
	prev_offset = current_offset
	return [prev_offset, car_laps]

func get_blue_car_speed():
	return blue_car_speed

func get_green_car_speed():
	return green_car_speed

func get_blue_car_lap():
	return blue_car_laps

func get_green_car_lap():
	return green_car_laps
