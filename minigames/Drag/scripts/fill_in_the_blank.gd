extends Control

# Signal to notify the main game when the puzzle is done
signal game_finished(success)

# --- Puzzle Data ---
# Default puzzle data (can be overridden with set_custom_data)
var puzzle_data = {
	"sentence_parts": [
		"Knowledge must be ", # Part 1
		", and someone ",      # Part 2
		" it."                 # Part 3
	],
	# Correct answers for DropZone1 and DropZone2 (Must match words in 'choices')
	"answers": ["protected", "stole"],
	"choices": [
		"protected", "instruction", "take", "text",
		"committed", "stole", "took", "make"
	]
}

# --- Node Paths (Verify these names match your Scene Dock EXACTLY) ---
# NOTE: Using Option B (Absolute Paths) for safety
@onready var sentence_line = $CanvasLayer/TextureRect/CenterContainer/PanelContainer/AspectRatioContainer/MarginContainer/VBoxContainer/HBoxContainer
@onready var choices_grid = $CanvasLayer/TextureRect/CenterContainer/PanelContainer/AspectRatioContainer/MarginContainer/VBoxContainer/GridContainer

# Assuming your drop zone ColorRects are named 'DropZone1' and 'DropZone2' or similar
# If they are auto-named ColorRect/ColorRect2, update the names in your scene or path
@onready var drop_zone_1 = $CanvasLayer/TextureRect/CenterContainer/PanelContainer/AspectRatioContainer/MarginContainer/VBoxContainer/HBoxContainer/drop1
@onready var drop_zone_2 = $CanvasLayer/TextureRect/CenterContainer/PanelContainer/AspectRatioContainer/MarginContainer/VBoxContainer/HBoxContainer/drop2

var correct_drops = 0
var total_drops = 2  # Will be set based on puzzle_data.answers.size()
const TILE_SCRIPT = preload("res://minigames/Drag/scripts/Tile.gd")
const DROP_SCRIPT = preload("res://minigames/Drag/scripts/DropZone.gd")

func set_custom_data(data: Dictionary):
	# Set custom puzzle data before _ready() is called
	if data.has("sentence_parts"):
		puzzle_data.sentence_parts = data.sentence_parts
	if data.has("answers"):
		puzzle_data.answers = data.answers
		total_drops = data.answers.size()
	if data.has("choices"):
		puzzle_data.choices = data.choices
	print("Custom puzzle data set: ", puzzle_data)

func _ready():
	total_drops = puzzle_data.answers.size()
	_initialize_puzzle()
	
func _initialize_puzzle():
	# 1. Set the sentence labels
	# NOTE: You may need to adjust the Label node names (Label, Label2, etc.)
	var labels = sentence_line.get_children().filter(func(c): return c is Label)
	if labels.size() >= 3:
		labels[0].text = puzzle_data.sentence_parts[0]
		labels[1].text = puzzle_data.sentence_parts[1]
		labels[2].text = puzzle_data.sentence_parts[2]

	# 2. Attach and initialize Drop Zone scripts
	drop_zone_1.set_script(DROP_SCRIPT)
	drop_zone_1.expected_answer = puzzle_data.answers[0]
	drop_zone_1.minigame_scene = self # Pass reference for callback
	drop_zone_1.name = "DropZone1" # Ensure the script knows its name

	drop_zone_2.set_script(DROP_SCRIPT)
	drop_zone_2.expected_answer = puzzle_data.answers[1]
	drop_zone_2.minigame_scene = self
	drop_zone_2.name = "DropZone2" # Ensure the script knows its name

	# 3. Initialize Draggable Tiles
	var choices = puzzle_data.choices.duplicate()
	choices.shuffle() # Randomize the tiles

	for i in range(choices_grid.get_child_count()):
		var tile_rect = choices_grid.get_child(i)

		# Attach Tile script and set the word
		tile_rect.set_script(TILE_SCRIPT)
		tile_rect.word_data = choices[i]

		# Assume the Label is the first child of the ColorRect tile
		tile_rect.get_node("Label").text = choices[i]
		
func check_win_condition(correctly_dropped):
	if correctly_dropped:
		correct_drops += 1

	if correct_drops == total_drops:
		# Win condition achieved!
		emit_signal("game_finished", true)
		print("Puzzle Solved!")
		await get_tree().create_timer(1.5).timeout
		queue_free()
	else:
		# Optionally handle failure/time runs out here
		pass
