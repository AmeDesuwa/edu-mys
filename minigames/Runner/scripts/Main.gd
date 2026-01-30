extends Node2D

signal game_finished(success: bool, score: int)

enum GameState { INIT, RUNNING, FINISHED }

@export var lane_count: int = 3
@export var correct_answers_needed: int = 5
@export var starting_health: int = 3
@export var starting_speed: float = 200.0
@export var starting_spawn_interval: float = 1.5

@export var speed_increase_every_sec: float = 10.0
@export var speed_increase_amount: float = 30.0
@export var max_speed: float = 500.0

@export var spawn_interval_decrease: float = 0.1
@export var min_spawn_interval: float = 0.6

# Provided by MinigameManager via `configure_puzzle()`
var questions: Array = []

# Runtime state
var score: int = 0
var health: int = 0
var current_question_index: int = 0

var lane_positions: Array[float] = []
var screen_size: Vector2

var current_correct_answer: String = ""
var current_wrong_answers: Array = []

var state: GameState = GameState.INIT
var configured: bool = false

var game_speed: float = 0.0
var spawn_interval: float = 0.0

var _spawn_timer: Timer
var _difficulty_timer: Timer
var _rng := RandomNumberGenerator.new()
var _active_objects: Array[Node2D] = []

var obstacle_scene = preload("res://minigames/Runner/scenes/Obstacle.tscn")
var collectible_scene = preload("res://minigames/Runner/scenes/Collectible.tscn")

func _ready() -> void:
	add_to_group("runner_main")
	_rng.randomize()

	screen_size = get_viewport_rect().size
	_setup_lanes()
	get_viewport().size_changed.connect(_on_viewport_size_changed)

	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	_spawn_timer.autostart = false
	add_child(_spawn_timer)
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	_difficulty_timer = Timer.new()
	_difficulty_timer.one_shot = false
	_difficulty_timer.autostart = false
	add_child(_difficulty_timer)
	_difficulty_timer.timeout.connect(_on_difficulty_timer_timeout)

	# Defer so MinigameManager can call `configure_puzzle()` first.
	call_deferred("_autostart_if_unconfigured")

func configure_puzzle(config: Dictionary) -> void:
	configured = true

	if config.has("questions"):
		questions = config.questions
	if config.has("answers_needed"):
		correct_answers_needed = config.answers_needed
	if config.has("starting_speed"):
		starting_speed = config.starting_speed
	if config.has("spawn_interval"):
		starting_spawn_interval = config.spawn_interval
	if config.has("starting_health"):
		starting_health = config.starting_health

	# `_ready()` may have already run; start safely here.
	if is_node_ready():
		_start_game()
	else:
		call_deferred("_start_game")

func _on_viewport_size_changed() -> void:
	screen_size = get_viewport_rect().size
	_setup_lanes()

func _setup_lanes() -> void:
	lane_positions.clear()
	if lane_count <= 0:
		return

	var lane_width := screen_size.x / float(lane_count)
	for i in range(lane_count):
		lane_positions.append(lane_width * i + lane_width / 2.0)

func get_lane_positions() -> Array:
	return lane_positions.duplicate()

func _start_game() -> void:
	if state == GameState.RUNNING:
		return

	state = GameState.RUNNING
	score = 0
	health = starting_health
	current_question_index = 0

	game_speed = starting_speed
	spawn_interval = starting_spawn_interval

	$UILayer/ResultPanel.hide()
	$UILayer/QuestionPanel.show()

	_load_question()
	_update_ui()

	_spawn_timer.wait_time = spawn_interval
	_spawn_timer.start()

	_difficulty_timer.wait_time = speed_increase_every_sec
	_difficulty_timer.start()

func _load_question() -> void:
	if questions.is_empty():
		$UILayer/QuestionLabel.text = "No questions configured."
		current_correct_answer = ""
		current_wrong_answers = []
		_clear_runner_objects()
		return

	if current_question_index >= questions.size():
		current_question_index = 0 # loop questions

	var q: Dictionary = questions[current_question_index]
	current_correct_answer = str(q.get("correct", ""))
	current_wrong_answers = q.get("wrong", []).duplicate()

	$UILayer/QuestionLabel.text = str(q.get("question", ""))
	$UILayer/QuestionPanel.show()

	# Prevent “old question” answers remaining on screen after advancing.
	_clear_runner_objects()

func _physics_process(delta: float) -> void:
	if state != GameState.RUNNING:
		return

	for obj in _active_objects:
		if not is_instance_valid(obj):
			continue
		obj.position.y += game_speed * delta
		if obj.position.y > screen_size.y + 80.0:
			obj.queue_free()

func _on_spawn_timer_timeout() -> void:
	if state != GameState.RUNNING:
		return
	_spawn_wave()

func _on_difficulty_timer_timeout() -> void:
	if state != GameState.RUNNING:
		return

	game_speed = min(game_speed + speed_increase_amount, max_speed)
	spawn_interval = max(spawn_interval - spawn_interval_decrease, min_spawn_interval)
	_spawn_timer.wait_time = spawn_interval

func _spawn_wave() -> void:
	if lane_positions.is_empty():
		return
	if current_correct_answer == "":
		return

	# Keep at most one correct collectible on screen at a time (reduces clutter).
	if _has_correct_collectible_on_screen():
		_spawn_wrong_only()
		return

	var available_lanes: Array[int] = []
	for i in range(lane_positions.size()):
		available_lanes.append(i)

	var correct_lane := available_lanes[_rng.randi_range(0, available_lanes.size() - 1)]
	available_lanes.erase(correct_lane)
	_spawn_collectible(Vector2(lane_positions[correct_lane], -60.0), current_correct_answer)

	# Spawn 1-2 wrong answers in other lanes
	var num_wrong := _rng.randi_range(1, min(2, available_lanes.size()))
	for i in range(num_wrong):
		var lane_idx := available_lanes[_rng.randi_range(0, available_lanes.size() - 1)]
		available_lanes.erase(lane_idx)
		_spawn_obstacle(Vector2(lane_positions[lane_idx], -60.0), _pick_wrong_answer())

func _spawn_wrong_only() -> void:
	# Optional: keep pressure on the player even when a correct collectible is present.
	var available_lanes: Array[int] = []
	for i in range(lane_positions.size()):
		available_lanes.append(i)

	var num_wrong := _rng.randi_range(1, min(2, available_lanes.size()))
	for i in range(num_wrong):
		var lane_idx := available_lanes[_rng.randi_range(0, available_lanes.size() - 1)]
		available_lanes.erase(lane_idx)
		_spawn_obstacle(Vector2(lane_positions[lane_idx], -60.0), _pick_wrong_answer())

func _pick_wrong_answer() -> String:
	if current_wrong_answers.size() <= 0:
		return "Wrong"
	return str(current_wrong_answers[_rng.randi_range(0, current_wrong_answers.size() - 1)])

func _has_correct_collectible_on_screen() -> bool:
	for obj in _active_objects:
		if not is_instance_valid(obj):
			continue
		if obj.get_meta("runner_is_correct", false):
			return true
	return false

func _spawn_collectible(pos: Vector2, answer: String) -> void:
	var collectible: Node2D = collectible_scene.instantiate()
	collectible.position = pos
	collectible.answer_text = answer
	collectible.set_meta("runner_is_correct", true)
	collectible.collected.connect(_on_collectible_collected)
	$GameLayer.add_child(collectible)
	_track_object(collectible)

func _spawn_obstacle(pos: Vector2, answer: String) -> void:
	var obstacle: Node2D = obstacle_scene.instantiate()
	obstacle.position = pos
	obstacle.answer_text = answer
	obstacle.hit_player.connect(_on_obstacle_hit)
	$GameLayer.add_child(obstacle)
	_track_object(obstacle)

func _track_object(obj: Node2D) -> void:
	_active_objects.append(obj)
	obj.tree_exited.connect(_on_object_tree_exited.bind(obj))

func _on_object_tree_exited(obj: Node2D) -> void:
	_active_objects.erase(obj)

func _clear_runner_objects() -> void:
	for obj in _active_objects:
		if is_instance_valid(obj):
			obj.queue_free()
	_active_objects.clear()

func _on_collectible_collected() -> void:
	score += 100

	_flash_screen(Color(0.2, 0.8, 0.2, 0.3))

	if score >= correct_answers_needed * 100:
		_end_game(true)
		return

	current_question_index += 1
	_load_question()
	_update_ui()

func _on_obstacle_hit() -> void:
	health -= 1

	_flash_screen(Color(0.8, 0.2, 0.2, 0.4))
	_shake_screen()

	if health <= 0:
		_end_game(false)
		return

	_update_ui()

func _flash_screen(color: Color) -> void:
	$UILayer/FlashRect.color = color
	$UILayer/FlashRect.show()

	var tween := create_tween()
	tween.tween_property($UILayer/FlashRect, "color:a", 0.0, 0.3)
	tween.tween_callback($UILayer/FlashRect.hide)

func _shake_screen() -> void:
	# CanvasLayer uses 'offset' instead of 'position'
	var original_offset: Vector2 = $GameLayer.offset
	var tween := create_tween()

	for i in range(5):
		var shake_offset := Vector2(_rng.randf_range(-10, 10), _rng.randf_range(-10, 10))
		tween.tween_property($GameLayer, "offset", original_offset + shake_offset, 0.05)
	tween.tween_property($GameLayer, "offset", original_offset, 0.05)

func _update_ui() -> void:
	$UILayer/ScoreLabel.text = "Score: " + str(score)
	$UILayer/HealthLabel.text = "Health: " + "❤️".repeat(max(health, 0))
	$UILayer/ProgressLabel.text = str(score / 100) + "/" + str(correct_answers_needed)

func _end_game(success: bool) -> void:
	if state == GameState.FINISHED:
		return
	state = GameState.FINISHED

	if is_instance_valid(_spawn_timer):
		_spawn_timer.stop()
	if is_instance_valid(_difficulty_timer):
		_difficulty_timer.stop()

	_clear_runner_objects()

	$UILayer/QuestionPanel.hide()
	$UILayer/ResultPanel.show()

	if success:
		$UILayer/ResultPanel/ResultLabel.text = "Great Job!\nScore: " + str(score)
		$UILayer/ResultPanel/ResultLabel.add_theme_color_override("font_color", Color(0.2, 0.8, 0.2))
	else:
		$UILayer/ResultPanel/ResultLabel.text = "Game Over\nScore: " + str(score)
		$UILayer/ResultPanel/ResultLabel.add_theme_color_override("font_color", Color(0.8, 0.2, 0.2))

	await get_tree().create_timer(2.5).timeout
	game_finished.emit(success, score)
	await get_tree().process_frame
	queue_free()

func _autostart_if_unconfigured() -> void:
	# If run standalone (not via MinigameManager), provide defaults.
	if configured:
		return
	if questions.is_empty():
		questions = [
			{"question": "What is the capital of France?", "correct": "Paris", "wrong": ["London", "Berlin", "Madrid"]},
			{"question": "What is 7 x 8?", "correct": "56", "wrong": ["54", "48", "64"]},
			{"question": "Which planet is closest to the Sun?", "correct": "Mercury", "wrong": ["Venus", "Mars", "Earth"]}
		]
	_start_game()
