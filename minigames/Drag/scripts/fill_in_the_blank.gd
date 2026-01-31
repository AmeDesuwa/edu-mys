extends Control

# Signal to notify the main game when the puzzle is done
signal game_finished(success: bool, score: int)

# --- Puzzle Data (now dynamic) ---
# Default puzzle data - can be overridden via configure_puzzle()
var puzzle_data = {
	"sentence_parts": [
		"A function assigns each ", # Part 1
		" to exactly one ",          # Part 2
		"."                          # Part 3
	],
	"answers": ["input", "output"],
	"choices": [
		"input", "output", "domain", "range",
		"variable", "constant", "equation", "value"
	],
	"title": "Complete the Sentence",
	"subtitle": "Drag the correct words into the blanks",
	"context": ""
}

var is_configured = false
var is_ready = false

# --- Node Paths ---
var header_path = "CanvasLayer/TextureRect/CenterContainer/PanelContainer/"
var header_path2 = "AspectRatioContainer/MarginContainer/VBoxContainer/ColorRect/MarginContainer/VBoxContainer/"
var content_path = "CanvasLayer/TextureRect/CenterContainer/PanelContainer/"
var content_path2 = "AspectRatioContainer/MarginContainer/VBoxContainer/"

@onready var sentence_line = get_node(content_path + content_path2 + "HBoxContainer")
@onready var choices_grid = get_node(content_path + content_path2 + "GridContainer")
@onready var drop_zone_1 = get_node(content_path + content_path2 + "HBoxContainer/drop1")
@onready var drop_zone_2 = get_node(content_path + content_path2 + "HBoxContainer/drop2")
@onready var texture_rect = $CanvasLayer/TextureRect

# Header labels (now configurable)
@onready var title_label = get_node(header_path + header_path2 + "TitleLabel")
@onready var subtitle_label = get_node(header_path + header_path2 + "SubtitleLabel")
@onready var context_label = get_node(header_path + header_path2 + "ContextLabel")

var correct_drops = 0
const TOTAL_DROPS = 2
const TILE_SCRIPT = preload("res://minigames/Drag/scripts/Tile.gd")
const DROP_SCRIPT = preload("res://minigames/Drag/scripts/DropZone.gd")

func _ready():
	is_ready = true
	# Quick fade-in for smooth transition
	texture_rect.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(texture_rect, "modulate:a", 1.0, 0.15)
	# Initialize puzzle now that nodes are ready
	_initialize_puzzle()

# Configure puzzle with external data from MinigameManager
func configure_puzzle(config: Dictionary) -> void:
	puzzle_data = {
		"sentence_parts": config.get("sentence_parts", []),
		"answers": config.get("answers", []),
		"choices": config.get("choices", []),
		"title": config.get("title", "Complete the Sentence"),
		"subtitle": config.get("subtitle", "Drag the correct words into the blanks"),
		"context": config.get("context", "")
	}
	is_configured = true
	# Only initialize if _ready() has already run, otherwise _ready() will handle it
	if is_ready:
		_initialize_puzzle()

func _initialize_puzzle():
	# 0. Set header labels if configured
	if puzzle_data.has("title"):
		title_label.text = puzzle_data.title
	if puzzle_data.has("subtitle"):
		subtitle_label.text = puzzle_data.subtitle
	if puzzle_data.has("context"):
		context_label.text = puzzle_data.context

	# 1. Set the sentence labels
	var labels = sentence_line.get_children().filter(func(c): return c is Label)
	if labels.size() >= 3 and puzzle_data.sentence_parts.size() >= 3:
		labels[0].text = puzzle_data.sentence_parts[0]
		labels[1].text = puzzle_data.sentence_parts[1]
		labels[2].text = puzzle_data.sentence_parts[2]

	# 2. Attach and initialize Drop Zone scripts
	drop_zone_1.set_script(DROP_SCRIPT)
	drop_zone_1.expected_answer = puzzle_data.answers[0]
	drop_zone_1.minigame_scene = self
	drop_zone_1.name = "DropZone1"

	drop_zone_2.set_script(DROP_SCRIPT)
	drop_zone_2.expected_answer = puzzle_data.answers[1]
	drop_zone_2.minigame_scene = self
	drop_zone_2.name = "DropZone2"

	# 3. Initialize Draggable Tiles
	var choices = puzzle_data.choices.duplicate()
	choices.shuffle()

	for i in range(choices_grid.get_child_count()):
		var tile_rect = choices_grid.get_child(i)
		if i < choices.size():
			tile_rect.set_script(TILE_SCRIPT)
			tile_rect.word_data = choices[i]
			tile_rect.get_node("Label").text = choices[i]
		else:
			tile_rect.visible = false

func check_win_condition(correctly_dropped):
	if correctly_dropped:
		correct_drops += 1

	if correct_drops == TOTAL_DROPS:
		# Win condition achieved!
		print("Puzzle Solved!")
		# Fade out before emitting signal and closing
		var tween = create_tween()
		tween.tween_property(texture_rect, "modulate:a", 0.0, 0.2)
		await tween.finished
		# Emit signal AFTER fade completes but BEFORE queue_free
		emit_signal("game_finished", true, 100)
		# Small delay to ensure signal is processed
		await get_tree().process_frame
		queue_free()
	else:
		# Optionally handle failure/time runs out here
		pass
