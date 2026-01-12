extends Node

# Signals
signal minigame_completed(success: bool, score: int)

# Current minigame tracking
var current_minigame: Node = null
var previous_scene: Node = null
var minigame_active: bool = false

# Minigame scene paths
const FILL_IN_BLANK_SCENE = "res://minigames/Drag/scenes/FillInTheBlank.tscn"
const PACMAN_SCENE = "res://minigames/Pacman/scenes/Main.tscn"

func _ready():
	print("MinigameManager initialized")

func start_fill_in_blank(question_data: Dictionary = {}):
	# Start the Fill-in-the-Blank minigame
	# question_data format:
	# {
	#     "sentence_parts": ["Part 1 ", " Part 2 ", " Part 3"],
	#     "answers": ["correct1", "correct2"],
	#     "choices": ["word1", "word2", "correct1", "correct2", ...]
	# }
	_start_minigame(FILL_IN_BLANK_SCENE, question_data)

func start_pacman(questions: Array = []):
	# Start the Pacman quiz minigame
	# questions format: Array of question dictionaries
	_start_minigame(PACMAN_SCENE, {"questions": questions})

func _start_minigame(scene_path: String, data: Dictionary = {}):
	if minigame_active:
		push_warning("MinigameManager: A minigame is already active")
		return

	print("MinigameManager: Starting minigame - ", scene_path)
	minigame_active = true

	# Load minigame scene
	var minigame_scene = load(scene_path)
	if not minigame_scene:
		push_error("MinigameManager: Failed to load minigame scene - ", scene_path)
		minigame_active = false
		return

	current_minigame = minigame_scene.instantiate()

	# Apply custom data if the minigame supports it
	if not data.is_empty() and current_minigame.has_method("set_custom_data"):
		current_minigame.set_custom_data(data)

	# Connect to minigame completion signal
	if current_minigame.has_signal("game_finished"):
		current_minigame.game_finished.connect(_on_minigame_finished)
	else:
		push_warning("MinigameManager: Minigame does not have 'game_finished' signal")

	# Add minigame to scene tree
	get_tree().root.add_child(current_minigame)

	# Pause Dialogic if it's running
	if Dialogic.current_timeline:
		Dialogic.paused = true
		print("MinigameManager: Dialogic paused")

func _on_minigame_finished(success: bool):
	print("MinigameManager: Minigame finished with success = ", success)

	# Calculate score (placeholder - can be enhanced)
	var score = 10 if success else 0

	# Clean up minigame
	if is_instance_valid(current_minigame):
		current_minigame.queue_free()
		current_minigame = null

	minigame_active = false

	# Resume Dialogic
	if Dialogic.current_timeline:
		Dialogic.paused = false
		print("MinigameManager: Dialogic resumed")

	# Emit completion signal
	minigame_completed.emit(success, score)

	# Auto-advance Dialogic to continue the story
	await get_tree().create_timer(0.1).timeout
	if Dialogic.current_timeline:
		Dialogic.Inputs.auto_advance.autoadvance.emit()

func is_minigame_active() -> bool:
	return minigame_active
