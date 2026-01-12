extends Control

# Signal to notify the main game when the puzzle is done
signal game_finished(success)

# --- Puzzle Data (now dynamic) ---
# Default puzzle data - can be overridden via configure_puzzle()
var puzzle_data = {
	"sentence_parts": [
		"Knowledge must be ", # Part 1
		", and someone ",      # Part 2
		" it."                 # Part 3
	],
	"answers": ["protected", "stole"],
	"choices": [
		"protected", "instruction", "take", "text",
		"committed", "stole", "took", "make"
	]
}

var is_configured = false
var is_ready = false

# --- Node Paths (Verify these names match your Scene Dock EXACTLY) ---
# NOTE: Using Option B (Absolute Paths) for safety
@onready var sentence_line = $CanvasLayer/TextureRect/CenterContainer/PanelContainer/AspectRatioContainer/MarginContainer/VBoxContainer/HBoxContainer
@onready var choices_grid = $CanvasLayer/TextureRect/CenterContainer/PanelContainer/AspectRatioContainer/MarginContainer/VBoxContainer/GridContainer

# Assuming your drop zone ColorRects are named 'DropZone1' and 'DropZone2' or similar
# If they are auto-named ColorRect/ColorRect2, update the names in your scene or path
@onready var drop_zone_1 = $CanvasLayer/TextureRect/CenterContainer/PanelContainer/AspectRatioContainer/MarginContainer/VBoxContainer/HBoxContainer/drop1
@onready var drop_zone_2 = $CanvasLayer/TextureRect/CenterContainer/PanelContainer/AspectRatioContainer/MarginContainer/VBoxContainer/HBoxContainer/drop2

var correct_drops = 0
const TOTAL_DROPS = 2
const TILE_SCRIPT = preload("res://minigames/Drag/scripts/Tile.gd")
const DROP_SCRIPT = preload("res://minigames/Drag/scripts/DropZone.gd")

func _ready():
	is_ready = true
	# Initialize puzzle now that nodes are ready
	_initialize_puzzle()

# Configure puzzle with external data from MinigameManager
func configure_puzzle(config: Dictionary) -> void:
	puzzle_data = {
		"sentence_parts": config.get("sentence_parts", []),
		"answers": config.get("answers", []),
		"choices": config.get("choices", [])
	}
	is_configured = true
	# Only initialize if _ready() has already run, otherwise _ready() will handle it
	if is_ready:
		_initialize_puzzle()

func _initialize_puzzle():
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
		emit_signal("game_finished", true)
		print("Puzzle Solved!")
		get_tree().create_timer(1.5).timeout.connect(queue_free)
	else:
		# Optionally handle failure/time runs out here
		pass
