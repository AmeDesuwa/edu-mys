extends Node

# Pause Manager - Handles escape key to pause/resume game and show pause menu

const PAUSE_MENU_SCENE := preload("res://scenes/ui/pause_menu.tscn")
const TEMP_SAVE_SLOT := "_pause_temp"

var pause_menu_instance: Control = null
var is_paused := false
var was_dialogic_paused := false

# Tracks whether we're in a context where pausing is allowed
var pause_enabled := false

func _ready() -> void:
	# Listen for when Dialogic starts/ends to enable/disable pausing
	if Dialogic.timeline_started.is_connected(_on_timeline_started) == false:
		Dialogic.timeline_started.connect(_on_timeline_started)
	if Dialogic.timeline_ended.is_connected(_on_timeline_ended) == false:
		Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_timeline_started() -> void:
	pause_enabled = true
	# Ensure Dialogic is not paused when timeline starts
	Dialogic.paused = false

func _on_timeline_ended() -> void:
	pause_enabled = false
	# Clean up pause menu if open when timeline ends
	if is_paused:
		_resume_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if is_paused:
			_resume_game()
			get_viewport().set_input_as_handled()
		elif pause_enabled:
			_pause_game()
			get_viewport().set_input_as_handled()

func _pause_game() -> void:
	if is_paused:
		return

	is_paused = true

	# Store Dialogic's pause state and pause it
	was_dialogic_paused = Dialogic.paused
	Dialogic.paused = true

	# Create and show pause menu
	pause_menu_instance = PAUSE_MENU_SCENE.instantiate()
	pause_menu_instance.resumed.connect(_on_resume)
	pause_menu_instance.settings_requested.connect(_on_settings)
	pause_menu_instance.main_menu_requested.connect(_on_main_menu)

	# Add to a CanvasLayer to ensure it's on top
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	canvas_layer.add_child(pause_menu_instance)
	get_tree().root.add_child(canvas_layer)

func _resume_game() -> void:
	if not is_paused:
		return

	is_paused = false

	# Remove pause menu
	if pause_menu_instance and is_instance_valid(pause_menu_instance):
		var canvas_layer = pause_menu_instance.get_parent()
		pause_menu_instance.queue_free()
		if canvas_layer:
			canvas_layer.queue_free()
		pause_menu_instance = null

	# Restore Dialogic's pause state
	Dialogic.paused = was_dialogic_paused

func _on_resume() -> void:
	_resume_game()

func _on_settings() -> void:
	# Save current game state to a temporary slot
	Dialogic.Save.save(TEMP_SAVE_SLOT, false, Dialogic.Save.ThumbnailMode.NONE)

	# Set flag so settings menu knows to load the temp save when returning
	var SettingsMenu = load("res://scripts/settings_menu.gd")
	SettingsMenu.opened_from_pause = true

	# Clean up pause menu
	_resume_game()

	# End timeline and go to settings
	Dialogic.end_timeline()
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")

func _on_main_menu() -> void:
	# Save game progress before returning to main menu
	Dialogic.Save.save("continue_save", false, Dialogic.Save.ThumbnailMode.NONE)
	PlayerStats.save_stats()

	_resume_game()
	# End the current timeline and go to main menu
	Dialogic.end_timeline()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

# Called by settings menu to restore game state
static func restore_from_pause() -> void:
	Dialogic.Save.load(TEMP_SAVE_SLOT)
