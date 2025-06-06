extends Node2D

const PAPER = preload("res://assets/paper.png")
const ROCK = preload("res://assets/rock.png")
const SCISSORS = preload("res://assets/scissors.png")

const HANDS = [ROCK, PAPER, SCISSORS]

@onready var player_texture: TextureRect = $CanvasLayer/Players/Player/TextureRect
@onready var computer_texture: TextureRect = $CanvasLayer/Players/Computer/TextureRect
@onready var outcome_label: Label = $CanvasLayer/Outcome
@onready var countdown_label: Label = $CanvasLayer/Countdown
@onready var timer: Timer = $Timer
@onready var rock_button: Button = %RockButton
@onready var paper_button: Button = %PaperButton
@onready var scissors_button: Button = %ScissorsButton


var player_choice: int
var computer_choice: int

var countdown_time: int = 3
var current_time: int

func _ready() -> void:
	player_texture.texture = null
	computer_texture.texture = null
	
	rock_button.disabled = true
	paper_button.disabled = true
	scissors_button.disabled = true
	
	rock_button.focus_mode = Control.FOCUS_NONE
	paper_button.focus_mode = Control.FOCUS_NONE
	scissors_button.focus_mode = Control.FOCUS_NONE
	
	countdown_label.text = str(current_time)
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	# start the timer and let player pick a hand
	if Input.is_action_just_pressed("start") and current_time <= 0:
		rock_button.disabled = false
		paper_button.disabled = false
		scissors_button.disabled = false
		
		rock_button.focus_mode = Control.FOCUS_ALL
		rock_button.grab_focus()
		paper_button.focus_mode = Control.FOCUS_ALL
		scissors_button.focus_mode = Control.FOCUS_ALL
		
		current_time = countdown_time
		countdown_label.text = str(current_time)
		timer.start()
	
	if rock_button.focus_entered:
		player_choice = 1
	elif paper_button.focus_entered:
		player_choice = 2
	elif scissors_button.focus_entered:
		player_choice = 3

func _on_timer_timeout():
	current_time -= 1
	countdown_label.text = str(current_time)
	
	if current_time <= 0:
		timer.stop()
		countdown_finished()

func countdown_finished():
	rock_button.disabled = true
	paper_button.disabled = true
	scissors_button.disabled = true
	
	rock_button.focus_mode = Control.FOCUS_NONE
	paper_button.focus_mode = Control.FOCUS_NONE
	scissors_button.focus_mode = Control.FOCUS_NONE
	
	computer_choice = randi() % 3
	
	player_texture.texture = HANDS[player_choice]
	computer_texture.texture = HANDS[computer_choice]
	
	check_hands()

func check_hands():
	if player_choice == computer_choice:
		outcome_label.text = "Draw"
	elif (player_choice - computer_choice + 3) % 3 == 1:
		outcome_label.text = "Won"
	else:
		outcome_label.text = "Lost"

func _on_rock_button_pressed() -> void:
	player_choice = 0

func _on_paper_button_pressed() -> void:
	player_choice = 1

func _on_scissors_button_pressed() -> void:
	player_choice = 2
