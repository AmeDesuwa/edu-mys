extends Control

@onready var new_game_button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/MenuButtons/NewGameButton
@onready var continue_button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/MenuButtons/ContinueButton
@onready var settings_button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/MenuButtons/SettingsButton
@onready var quit_button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/MenuButtons/QuitButton

func _ready() -> void:
	# Check if a Dialogic save exists to enable/disable continue button
	var has_save = Dialogic.Save.has_slot("continue_save")
	continue_button.disabled = not has_save

	# Connect button signals
	new_game_button.pressed.connect(_on_new_game_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _input(event: InputEvent) -> void:
	# Debug: Press Delete key to clear all save data
	if event.is_action_pressed("ui_text_delete"):
		if Dialogic.Save.has_slot("continue_save"):
			Dialogic.Save.delete_slot("continue_save")
			print("DEBUG: Save data cleared!")
			continue_button.disabled = true

func _on_new_game_pressed() -> void:
	# Reset player stats for new game
	PlayerStats.reset_stats()

	# Clear any existing continue save to start fresh
	if Dialogic.Save.has_slot("continue_save"):
		Dialogic.Save.delete_slot("continue_save")

	# Ensure Dialogic is not paused
	Dialogic.paused = false

	# Reset Dialogic variables for new game
	Dialogic.VAR.conrad_level = 1
	Dialogic.VAR.chapter1_score = 0
	Dialogic.VAR.chapter2_score = 0
	Dialogic.VAR.chapter3_score = 0
	Dialogic.VAR.chapter4_score = 0
	Dialogic.VAR.chapter5_score = 0
	Dialogic.VAR.minigames_completed = 0

	# Switch to game scene and start the timeline
	get_tree().change_scene_to_file("res://node_2d.tscn")

func _on_continue_pressed() -> void:
	# Load saved game stats
	PlayerStats.load_stats()

	# Set flag so game scene knows to load save instead of starting fresh
	var GameScene = load("res://node_2d.gd")
	GameScene.load_continue_save = true

	# Switch to game scene (it will load the save in _ready)
	get_tree().change_scene_to_file("res://node_2d.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
