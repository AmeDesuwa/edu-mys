extends Control

@onready var resume_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var settings_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/SettingsButton
@onready var main_menu_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MainMenuButton

signal resumed
signal settings_requested
signal main_menu_requested

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

	# Focus on resume button by default
	resume_button.grab_focus()

func _on_resume_pressed() -> void:
	resumed.emit()

func _on_settings_pressed() -> void:
	settings_requested.emit()

func _on_main_menu_pressed() -> void:
	main_menu_requested.emit()
