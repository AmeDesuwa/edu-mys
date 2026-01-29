extends Node2D

signal game_finished(success: bool, score: int)

# Maze configuration - using preset map dimensions
const CELL_SIZE = 32  # Larger cells for better visibility
var maze_width: int = 31
var maze_height: int = 23

# Cell types
enum Cell { WALL, FLOOR }

# Game state
var maze: Array = []
var questions: Array = []
var current_question_index: int = 0
var score: int = 0
var health: int = 3
var game_active: bool = false
var answers_collected: int = 0
var current_map_index: int = -1  # -1 = random, 0-2 = specific map

# Preset map data
var start_pos: Vector2i = Vector2i(1, 1)
var answer_spots: Array = []  # Dedicated spots for correct answers

# Scenes
var collectible_scene = preload("res://minigames/Maze/scenes/Collectible.tscn")

# Colors
const WALL_COLOR = Color(0.25, 0.2, 0.35, 1)
const FLOOR_COLOR = Color(0.9, 0.87, 0.8, 1)
const PLAYER_START_COLOR = Color(0.3, 0.8, 0.4, 0.4)

func _ready():
	# Quick fade-in for smooth transition
	modulate.a = 0.0
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, 0.15)

	# Default questions for testing
	questions = [
		{"question": "2 + 2 = ?", "correct": "4", "wrong": ["3", "5", "6"]},
		{
			"question": "Capital of France?",
			"correct": "Paris",
			"wrong": ["London", "Berlin", "Rome"]
		},
		{
			"question": "Largest planet?",
			"correct": "Jupiter",
			"wrong": ["Mars", "Saturn", "Earth"]
		},
		{"question": "H2O is?", "correct": "Water", "wrong": ["Air", "Fire", "Salt"]},
		{"question": "7 x 8 = ?", "correct": "56", "wrong": ["54", "58", "48"]}
	]
	_start_game()

func configure_puzzle(config: Dictionary):
	if config.has("questions"):
		questions = config.questions
	if config.has("map_index"):
		current_map_index = config.map_index

func _start_game():
	game_active = true
	score = 0
	health = 3
	current_question_index = 0
	answers_collected = 0

	_load_preset_map()
	_draw_maze()
	_place_answers()
	_setup_player()
	_update_ui()

func _load_preset_map():
	# Select map based on index or random if -1
	var map_data: Array
	if current_map_index >= 0:
		map_data = PresetMaps.get_map(current_map_index)
	else:
		map_data = PresetMaps.get_random_map()

	var parsed = PresetMaps.parse_map(map_data)

	maze = parsed.maze
	start_pos = parsed.start
	answer_spots = parsed.answer_spots
	maze_width = parsed.width
	maze_height = parsed.height

	# Debug output
	print("Loaded preset map ", current_map_index, ": ", maze_width, "x", maze_height)
	print("Start position: ", start_pos)
	print("Answer spots: ", answer_spots)

# ============ MAZE LOADING (Preset Maps) ============
# Maze generation is now handled by PresetMaps class
# See _load_preset_map() for map loading logic

# ============ DRAWING ============

func _draw_maze():
	# Clear existing maze visuals (but keep the Player!)
	for child in $MazeLayer.get_children():
		if child.name != "Player":
			child.queue_free()

	for y in range(maze_height):
		for x in range(maze_width):
			var cell_rect = ColorRect.new()
			cell_rect.size = Vector2(CELL_SIZE, CELL_SIZE)
			cell_rect.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)

			if maze[y][x] == Cell.WALL:
				cell_rect.color = WALL_COLOR
			else:
				cell_rect.color = FLOOR_COLOR

			$MazeLayer.add_child(cell_rect)

	# Highlight player start position from map data
	var start_highlight = ColorRect.new()
	start_highlight.size = Vector2(CELL_SIZE, CELL_SIZE)
	start_highlight.position = Vector2(start_pos.x * CELL_SIZE, start_pos.y * CELL_SIZE)
	start_highlight.color = PLAYER_START_COLOR
	$MazeLayer.add_child(start_highlight)

# ============ PATHFINDING (BFS) ============

func _find_path(from_pos: Vector2i, to_pos: Vector2i) -> Array:
	# BFS to find shortest path between two floor positions
	var queue: Array = [[from_pos]]
	var visited: Dictionary = {from_pos: true}

	var directions = [
		Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)
	]

	while queue.size() > 0:
		var path = queue.pop_front()
		var current = path[-1]

		if current == to_pos:
			return path

		for dir in directions:
			var next = current + dir
			if next.x >= 0 and next.x < maze_width and next.y >= 0 and next.y < maze_height:
				if maze[next.y][next.x] == Cell.FLOOR and not visited.has(next):
					visited[next] = true
					var new_path = path.duplicate()
					new_path.append(next)
					queue.append(new_path)

	return []  # No path found

func _get_reachable_positions(from_pos: Vector2i, exclude: Array = []) -> Array:
	# Get all floor positions reachable from a starting point
	var reachable: Array = []
	var queue: Array = [from_pos]
	var visited: Dictionary = {from_pos: true}

	var directions = [
		Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)
	]

	while queue.size() > 0:
		var current = queue.pop_front()

		if current != from_pos and not exclude.has(current):
			reachable.append(current)

		for dir in directions:
			var next = current + dir
			if next.x >= 0 and next.x < maze_width and next.y >= 0 and next.y < maze_height:
				if maze[next.y][next.x] == Cell.FLOOR and not visited.has(next):
					visited[next] = true
					queue.append(next)

	return reachable

# ============ ANSWER PLACEMENT ============

func _place_answers():
	# Clear existing collectibles
	for child in $CollectibleLayer.get_children():
		child.queue_free()

	var used_positions: Array = []

	# Get all floor positions with their distance from start using BFS
	var positions_with_distance = _get_positions_by_distance_from_start()

	# Place correct answers at increasing distances (ensures they're reachable in order)
	var num_questions = min(questions.size(), 5)
	var positions_per_question = max(1, positions_with_distance.size() / (num_questions + 2))  # +2 for spacing

	for q_index in range(num_questions):
		var q = questions[q_index]
		# Pick position at progressive distance intervals
		var position_index = min((q_index + 1) * positions_per_question, positions_with_distance.size() - 1)
		var pos = positions_with_distance[position_index]["pos"]

		_spawn_collectible(pos, q.correct, q_index, true)
		used_positions.append(pos)
		print("DEBUG: Placed Q", q_index + 1, " correct answer at ", pos, " (distance ", positions_with_distance[position_index]["distance"], ")")

	# Collect remaining floor positions for wrong answer placement
	var floor_positions: Array = []
	for entry in positions_with_distance:
		var pos = entry["pos"]

		# Skip if already used (correct answer)
		if used_positions.has(pos):
			continue

		# Skip start area
		if pos.x <= 2 and pos.y <= 2:
			continue

		# Skip positions too close to correct answers (avoid confusion)
		var too_close = false
		for used_pos in used_positions:
			if abs(pos.x - used_pos.x) <= 2 and abs(pos.y - used_pos.y) <= 2:
				too_close = true
				break

		if not too_close:
			floor_positions.append(pos)

	# Shuffle and place wrong answers
	floor_positions.shuffle()
	var floor_index = 0

	for q_index in range(num_questions):
		var q = questions[q_index]
		# Place 2 wrong answers per question
		for i in range(min(2, q.wrong.size())):
			if floor_index < floor_positions.size():
				var pos = floor_positions[floor_index]
				_spawn_collectible(pos, q.wrong[i], q_index, false)
				used_positions.append(pos)
				floor_index += 1

# Get all floor positions sorted by distance from start (BFS)
func _get_positions_by_distance_from_start() -> Array:
	var result: Array = []
	var queue: Array = [[start_pos, 0]]  # [position, distance]
	var visited: Dictionary = {start_pos: true}

	var directions = [
		Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)
	]

	while queue.size() > 0:
		var current_data = queue.pop_front()
		var current = current_data[0]
		var distance = current_data[1]

		result.append({"pos": current, "distance": distance})

		for dir in directions:
			var next = current + dir
			if next.x >= 0 and next.x < maze_width and next.y >= 0 and next.y < maze_height:
				if maze[next.y][next.x] == Cell.FLOOR and not visited.has(next):
					visited[next] = true
					queue.append([next, distance + 1])

	return result

func _spawn_collectible(
		grid_pos: Vector2i, answer_text: String, q_index: int, is_correct: bool
	):
	var collectible = collectible_scene.instantiate()
	var pos_x = grid_pos.x * CELL_SIZE + CELL_SIZE / 2
	var pos_y = grid_pos.y * CELL_SIZE + CELL_SIZE / 2
	collectible.position = Vector2(pos_x, pos_y)
	collectible.z_index = 5  # Render on top of maze tiles
	collectible.setup(answer_text, q_index, is_correct)
	collectible.collected.connect(_on_answer_collected)
	$CollectibleLayer.add_child(collectible)

# ============ PLAYER ============

func _setup_player():
	var player = $MazeLayer/Player
	# Use start position from preset map
	player.position = Vector2(
		start_pos.x * CELL_SIZE + CELL_SIZE / 2,
		start_pos.y * CELL_SIZE + CELL_SIZE / 2
	)
	player.cell_size = CELL_SIZE
	player.maze_width = maze_width
	player.maze_height = maze_height
	player.z_index = 10  # Render on top of maze tiles
	player.set_maze(maze)
	var cols = maze[0].size() if maze.size() > 0 else 0
	print("DEBUG: Player maze set, size: ", maze.size(), " x ", cols)

# ============ GAME LOGIC ============

func _on_answer_collected(collectible: Node, _answer_text: String, question_index: int, is_correct: bool):
	if not game_active:
		return

	# Check if this is the answer for the CURRENT question
	if question_index == current_question_index and is_correct:
		# Correct answer for current question! Remove it.
		collectible.confirm_collect()
		score += 100
		answers_collected += 1
		current_question_index += 1
		_flash_screen(Color(0.2, 0.8, 0.2, 0.3))
		_show_feedback("Correct!", Color(0.2, 0.8, 0.2))

		if current_question_index >= questions.size():
			# All questions answered!
			_end_game(true)
	elif question_index != current_question_index and is_correct:
		# Correct answer but WRONG order - DON'T remove, just warn
		collectible.wrong_order_feedback()
		health -= 1
		_flash_screen(Color(0.8, 0.6, 0.2, 0.4))
		_show_feedback("Wrong order! Get Q" + str(current_question_index + 1) + " first!", Color(0.8, 0.6, 0.2))
		_check_game_over()
	else:
		# Wrong answer - remove it as penalty
		collectible.reject_collect()
		health -= 1
		_flash_screen(Color(0.8, 0.2, 0.2, 0.4))
		_show_feedback("Wrong!", Color(0.8, 0.2, 0.2))
		_check_game_over()

	_update_ui()

func _check_game_over():
	if health <= 0:
		_end_game(false)

func _end_game(success: bool):
	game_active = false
	$MazeLayer/Player.set_physics_process(false)

	var result_text = "Victory!" if success else "Game Over"
	$UILayer/ResultPanel.show()
	$UILayer/ResultPanel/ResultLabel.text = result_text

	# Emit signal after delay, then fade out
	await get_tree().create_timer(1.5).timeout
	emit_signal("game_finished", success, score)
	# Wait a frame to ensure signal is processed before cleanup
	await get_tree().process_frame
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.2)
	fade_tween.tween_callback(get_parent().queue_free)

# ============ UI ============

func _update_ui():
	# Update health display
	var hearts = ""
	for i in range(health):
		hearts += "♥"
	for i in range(3 - health):
		hearts += "♡"
	$UILayer/HealthLabel.text = hearts

	# Update score
	$UILayer/ScoreLabel.text = "Score: " + str(score)

	# Update question queue
	_update_question_queue()

func _update_question_queue():
	var queue_text = ""
	for i in range(questions.size()):
		var q = questions[i]
		var prefix = ""
		if i < current_question_index:
			prefix = "[✓] "  # Completed
		elif i == current_question_index:
			prefix = "→ "  # Current
		else:
			prefix = "   "  # Upcoming

		queue_text += prefix + str(i + 1) + ". " + q.question + "\n"

	$UILayer/QuestionQueue.text = queue_text

func _show_feedback(text: String, color: Color):
	var feedback = $UILayer/FeedbackLabel
	feedback.text = text
	feedback.modulate = color
	feedback.show()

	var tween = create_tween()
	tween.tween_property(feedback, "modulate:a", 0.0, 1.0)
	tween.tween_callback(feedback.hide)

func _flash_screen(color: Color):
	$UILayer/FlashRect.color = color
	$UILayer/FlashRect.show()

	var tween = create_tween()
	tween.tween_property($UILayer/FlashRect, "modulate:a", 0.0, 0.3)
	tween.tween_callback($UILayer/FlashRect.hide)
	tween.tween_callback(func(): $UILayer/FlashRect.modulate.a = 1.0)
