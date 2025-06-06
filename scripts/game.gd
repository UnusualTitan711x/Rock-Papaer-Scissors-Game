extends Node2D

# Preload hand textures for Rock, Paper, Scissors
const PAPER = preload("res://assets/paper.png")
const ROCK = preload("res://assets/rock.png")
const SCISSORS = preload("res://assets/scissors.png")

# Store textures in an array so we can index them by hand (0 = Rock, 1 = Paper, 2 = Scissors)
const HANDS = [ROCK, PAPER, SCISSORS]

# References to UI elements (automatically assigned when the scene is ready)
@onready var player_texture: TextureRect = $CanvasLayer/Players/Player/TextureRect
@onready var computer_texture: TextureRect = $CanvasLayer/Players/Computer/TextureRect
@onready var outcome_label: Label = $CanvasLayer/Outcome
@onready var countdown_label: Label = $CanvasLayer/Countdown
@onready var timer: Timer = $Timer
@onready var rock_button: Button = %RockButton
@onready var paper_button: Button = %PaperButton
@onready var scissors_button: Button = %ScissorsButton
@onready var play_button: Button = $CanvasLayer/PlayButton

# Variables to store player and computer choices
var player_choice: int
var computer_choice: int

# Countdown settings
var countdown_time: int = 3
var current_time: int

func _ready() -> void:
	# Clear any previous hand images
	player_texture.texture = null
	computer_texture.texture = null

	# Disable hand selection buttons at start
	rock_button.disabled = true
	paper_button.disabled = true
	scissors_button.disabled = true

	# Disable focus on hand buttons until the game starts
	rock_button.focus_mode = Control.FOCUS_NONE
	paper_button.focus_mode = Control.FOCUS_NONE
	scissors_button.focus_mode = Control.FOCUS_NONE

	# Connect focus signals to simulate button presses when buttons are focused
	rock_button.focus_entered.connect(_on_rock_button_pressed)
	paper_button.focus_entered.connect(_on_paper_button_pressed)
	scissors_button.focus_entered.connect(_on_scissors_button_pressed)

	# Show initial countdown value
	countdown_label.text = str(current_time)

	# Connect the timer’s timeout signal to its handler
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	# Start the game when 'start' is pressed or play button is held and countdown is finished
	if (Input.is_action_just_pressed("start") or play_button.button_pressed) and current_time <= 0:
		# Clear previous round visuals
		player_texture.texture = null
		computer_texture.texture = null

		# Enable hand selection buttons
		rock_button.disabled = false
		paper_button.disabled = false
		scissors_button.disabled = false

		# Enable focus navigation for the buttons
		rock_button.focus_mode = Control.FOCUS_ALL
		rock_button.grab_focus()  # Automatically focus rock button
		paper_button.focus_mode = Control.FOCUS_ALL
		scissors_button.focus_mode = Control.FOCUS_ALL
		play_button.focus_mode = Control.FOCUS_NONE  # Remove focus from play button

		# Start countdown
		current_time = countdown_time
		countdown_label.text = str(current_time)
		timer.start()

func _on_timer_timeout():
	# Countdown step
	current_time -= 1
	countdown_label.text = str(current_time)

	# When countdown is finished, stop timer and evaluate round
	if current_time <= 0:
		timer.stop()
		countdown_finished()

func countdown_finished():
	# Disable hand buttons after selection
	rock_button.disabled = true
	paper_button.disabled = true
	scissors_button.disabled = true

	# Remove focus from hand buttons, return focus to play button
	rock_button.focus_mode = Control.FOCUS_NONE
	paper_button.focus_mode = Control.FOCUS_NONE
	scissors_button.focus_mode = Control.FOCUS_NONE
	play_button.focus_mode = Control.FOCUS_ALL

	# Randomly select a hand for the computer
	computer_choice = randi() % 3

	# Display both player and computer hand textures
	player_texture.texture = HANDS[player_choice]
	computer_texture.texture = HANDS[computer_choice]

	# Check outcome of the round
	check_hands()

func check_hands():
	# Determine and display outcome: Draw, Win, or Lose
	if player_choice == computer_choice:
		outcome_label.text = "Draw"
	elif (player_choice - computer_choice + 3) % 3 == 1:
		outcome_label.text = "Won"
	else:
		outcome_label.text = "Lost"

# These functions set the player_choice based on which button is focused
func _on_rock_button_pressed() -> void:
	player_choice = 0  # Rock

func _on_paper_button_pressed() -> void:
	player_choice = 1  # Paper

func _on_scissors_button_pressed() -> void:
	player_choice = 2  # Scissors
