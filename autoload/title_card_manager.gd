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

	current_title_card = title_card_scene.instantiate()
	get_tree().root.add_child(current_title_card)
	current_title_card.title_card_finished.connect(_on_title_card_finished)
	current_title_card.show_title_card_v2(config.image, config.title)

func show_custom_title(image_path: String, title_text: String) -> void:
	if current_title_card:
		push_warning("Title card already active")
		return

	current_title_card = title_card_scene.instantiate()
	get_tree().root.add_child(current_title_card)
	current_title_card.title_card_finished.connect(_on_title_card_finished)
	current_title_card.show_title_card_v2(image_path, title_text)

func _on_title_card_finished() -> void:
	current_title_card = null
	title_card_completed.emit()
