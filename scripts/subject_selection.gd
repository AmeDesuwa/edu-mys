extends Control

@onready var math_button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/SubjectButtons/MathButton
@onready var science_button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/SubjectButtons/ScienceButton
@onready var english_button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/SubjectButtons/EnglishButton
@onready var description_label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/DescriptionLabel
@onready var back_button = $BackButton

var subject_descriptions = {
	"math": "Functions, Trigonometry, Statistics & Probability\nGrades 11-12 General Mathematics curriculum",
	"science": "Earth Science, Biology, Chemistry & Physics\nGrades 11-12 Physical Science curriculum",
	"english": "Communication, Grammar, Literature & Writing\nGrades 11-12 Oral Communication curriculum"
}

func _ready() -> void:
	# Connect button signals
	math_button.pressed.connect(_on_subject_selected.bind("math"))
	science_button.pressed.connect(_on_subject_selected.bind("science"))
	english_button.pressed.connect(_on_subject_selected.bind("english"))
	back_button.pressed.connect(_on_back_pressed)

	# Connect hover signals
	math_button.mouse_entered.connect(_show_description.bind("math"))
	science_button.mouse_entered.connect(_show_description.bind("science"))
	english_button.mouse_entered.connect(_show_description.bind("english"))

	# Reset description on mouse exit
	math_button.mouse_exited.connect(_reset_description)
	science_button.mouse_exited.connect(_reset_description)
	english_button.mouse_exited.connect(_reset_description)

func _show_description(subject: String) -> void:
	description_label.text = subject_descriptions.get(subject, "")

func _reset_description() -> void:
	description_label.text = "Hover over a subject to see curriculum details"

func _on_subject_selected(subject: String) -> void:
	# Set the selected subject
	Dialogic.VAR.selected_subject = subject
	Dialogic.VAR.current_chapter = 1

	# Start the game
	get_tree().change_scene_to_file("res://node_2d.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
