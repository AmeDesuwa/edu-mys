extends Control

@onready var new_game_button = $MarginContainer/VBoxContainer/MenuButtons/NewGameButton
@onready var continue_button = $MarginContainer/VBoxContainer/MenuButtons/ContinueButton
@onready var settings_button = $MarginContainer/VBoxContainer/MenuButtons/SettingsButton
@onready var quit_button = $MarginContainer/VBoxContainer/MenuButtons/QuitButton

func _ready() -> void:
	# Check if save file exists to enable/disable continue button
	if not PlayerStats.save_exists():
		continue_button.disabled = true

	# Connect button signals
	new_game_button.pressed.connect(_on_new_game_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_new_game_pressed() -> void:
	# Reset player stats for new game
	PlayerStats.reset_stats()

	# Reset Dialogic variables for new game
	Dialogic.VAR.conrad_level = 1
	Dialogic.VAR.chapter1_score = 0
	Dialogic.VAR.chapter2_score = 0
	Dialogic.VAR.chapter3_score = 0
	Dialogic.VAR.chapter4_score = 0
	Dialogic.VAR.chapter5_score = 0
	Dialogic.VAR.minigames_completed = 0

	# Start the game from Chapter 1 Scene 1
	Dialogic.start("c1s1")

func _on_continue_pressed() -> void:
	# Load saved game
	PlayerStats.load_stats()

	# TODO: Implement chapter selection or continue from last position
	# For now, just start from c1s1 with loaded stats
	Dialogic.start("c1s1")

func _on_settings_pressed() -> void:
	# TODO: Open settings menu
	print("Settings menu not yet implemented")
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
