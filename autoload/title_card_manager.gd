extends Node

signal title_card_completed

var title_card_scene = preload("res://scenes/ui/title_card.tscn")
var current_title_card = null

# Chapter title cards configuration - image path and title text
var chapter_configs = {
	"1": {
		"image": "res://Bg/faculty_exam.png",
		"title": "Chapter 1:  The Stolen Exam Papers"
	},
	"2": {
		"image": "res://Bg/classroom.png",
		"title": "Chapter 2:  The Missing Fund"
	},
	"3": {
		"image": "res://Bg/art_room.png",
		"title": "Chapter 3:  The Broken Sculpture"
	},
	"4": {
		"image": "res://Bg/library_archive.png",
		"title": "Chapter 4:  The Hidden Journal"
	},
	"5": {
		"image": "res://Bg/principal_office.png",
		"title": "Chapter 5:  The Teacher Revealed"
	}
}

func show_chapter_title(chapter_number: String) -> void:
	if current_title_card:
		push_warning("Title card already active")
		return

	var config = chapter_configs.get(chapter_number)
	if not config:
		push_error("No title card config for chapter: " + chapter_number)
		return

	# Hide evidence button during title card
	_hide_evidence_button_during_title_card()

	current_title_card = title_card_scene.instantiate()
	get_tree().root.add_child(current_title_card)
	current_title_card.title_card_finished.connect(_on_title_card_finished)
	current_title_card.show_title_card_v2(config.image, config.title)

func show_custom_title(image_path: String, title_text: String) -> void:
	if current_title_card:
		push_warning("Title card already active")
		return

	# Hide evidence button during title card
	_hide_evidence_button_during_title_card()

	current_title_card = title_card_scene.instantiate()
	get_tree().root.add_child(current_title_card)
	current_title_card.title_card_finished.connect(_on_title_card_finished)
	current_title_card.show_title_card_v2(image_path, title_text)

func _on_title_card_finished() -> void:
	current_title_card = null
	# Show evidence button after title card ends (if dialogic is active)
	_show_evidence_button_after_title_card()
	title_card_completed.emit()

func _hide_evidence_button_during_title_card():
	# Method 1: Try to hide via EvidenceButtonManager
	var evidence_button_manager = get_node("/root/EvidenceButtonManager")
	if evidence_button_manager:
		evidence_button_manager.hide_evidence_button()
	
	# Method 2: Directly find and hide any evidence button instances in the scene tree
	_find_and_hide_evidence_buttons(get_tree().root)

func _find_and_hide_evidence_buttons(node: Node):
	# Look for evidence button instances by name or type
	if node is CanvasLayer and node.name == "EvidenceButton":
		node.visible = false
	
	# Recursively check all children
	for child in node.get_children():
		_find_and_hide_evidence_buttons(child)

func _show_evidence_button_after_title_card():
	# Method 1: Try to show via EvidenceButtonManager
	var evidence_button_manager = get_node("/root/EvidenceButtonManager")
	if evidence_button_manager:
		# Only show if dialogic is currently active
		if evidence_button_manager.button_enabled:
			evidence_button_manager.show_evidence_button()
	
	# Method 2: Directly find and show evidence button instances
	_find_and_show_evidence_buttons(get_tree().root)

func _find_and_show_evidence_buttons(node: Node):
	# Look for evidence button instances by name or type
	if node is CanvasLayer and node.name == "EvidenceButton":
		node.visible = true
	
	# Recursively check all children
	for child in node.get_children():
		_find_and_show_evidence_buttons(child)
