extends Node2D

signal game_finished(success: bool, score: int)

# Maze configuration - using odd dimensions for proper maze structure
const CELL_SIZE = 26
const MAZE_WIDTH = 45  # Must be odd
const MAZE_HEIGHT = 35  # Must be odd

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
var regeneration_attempts: int = 0
const MAX_REGENERATION_ATTEMPTS = 10

# For pathfinding and answer placement
var solution_path: Array = []  # The golden path through correct answers

# Scenes
var collectible_scene = preload("res://minigames/Maze/scenes/Collectible.tscn")

# Colors
const WALL_COLOR = Color(0.25, 0.2, 0.35, 1)
const FLOOR_COLOR = Color(0.9, 0.87, 0.8, 1)
const PLAYER_START_COLOR = Color(0.3, 0.8, 0.4, 0.4)

func _ready():
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

func _start_game():
	game_active = true
	score = 0
	health = 3
	current_question_index = 0
	answers_collected = 0
	regeneration_attempts = 0

	_generate_maze()
	_draw_maze()
	_place_answers()
	_setup_player()
	_update_ui()

# ============ MAZE GENERATION (Proper Recursive Backtracking) ============

func _generate_maze():
	# Initialize maze with all walls
	maze = []
	for y in range(MAZE_HEIGHT):
		var row = []
		for x in range(MAZE_WIDTH):
			row.append(Cell.WALL)
		maze.append(row)

	# Use iterative approach with stack to avoid recursion limit
	var stack: Array = []
	var start_x = 1
	var start_y = 1

	maze[start_y][start_x] = Cell.FLOOR
	stack.append(Vector2i(start_x, start_y))

	while stack.size() > 0:
		var current = stack[-1]
		var x = current.x
		var y = current.y

		# Get unvisited neighbors (2 cells away)
		var neighbors: Array = []

		# Check all 4 directions
		if x >= 3 and maze[y][x - 2] == Cell.WALL:
			neighbors.append(Vector2i(x - 2, y))
		if x <= MAZE_WIDTH - 4 and maze[y][x + 2] == Cell.WALL:
			neighbors.append(Vector2i(x + 2, y))
		if y >= 3 and maze[y - 2][x] == Cell.WALL:
			neighbors.append(Vector2i(x, y - 2))
		if y <= MAZE_HEIGHT - 4 and maze[y + 2][x] == Cell.WALL:
			neighbors.append(Vector2i(x, y + 2))

		if neighbors.size() > 0:
			# Choose random neighbor
			var next = neighbors[randi() % neighbors.size()]

			# Carve passage (remove wall between current and next)
			var wall_x = int((x + next.x) / 2)
			var wall_y = int((y + next.y) / 2)
			maze[wall_y][wall_x] = Cell.FLOOR
			maze[next.y][next.x] = Cell.FLOOR

			stack.append(next)
		else:
			# Backtrack
			stack.pop_back()

	# Add a few extra connections to create some loops (makes it less linear)
	_add_sparse_connections()

func _add_sparse_connections():
	# Add a small number of extra passages to create alternate routes
	# This prevents the maze from being completely linear
	var connections_to_add = int((MAZE_WIDTH + MAZE_HEIGHT) / 6)

	for i in range(connections_to_add):
		# Try to find a wall that can become a passage
		for attempt in range(50):
			# Pick a random wall position (must be on odd coordinates for proper structure)
			var x = randi_range(2, MAZE_WIDTH - 3)
			var y = randi_range(2, MAZE_HEIGHT - 3)

			if maze[y][x] == Cell.WALL:
				# Check if this wall separates two floor cells horizontally
				if x > 0 and x < MAZE_WIDTH - 1:
					if maze[y][x - 1] == Cell.FLOOR and maze[y][x + 1] == Cell.FLOOR:
						maze[y][x] = Cell.FLOOR
						break
				# Or vertically
				if y > 0 and y < MAZE_HEIGHT - 1:
					if maze[y - 1][x] == Cell.FLOOR and maze[y + 1][x] == Cell.FLOOR:
						maze[y][x] = Cell.FLOOR
						break

# ============ DRAWING ============

func _draw_maze():
	# Clear existing maze visuals (but keep the Player!)
	for child in $MazeLayer.get_children():
		if child.name != "Player":
			child.queue_free()

	for y in range(MAZE_HEIGHT):
		for x in range(MAZE_WIDTH):
			var cell_rect = ColorRect.new()
			cell_rect.size = Vector2(CELL_SIZE, CELL_SIZE)
			cell_rect.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)

			if maze[y][x] == Cell.WALL:
				cell_rect.color = WALL_COLOR
			else:
				cell_rect.color = FLOOR_COLOR

			$MazeLayer.add_child(cell_rect)

	# Highlight player start
	var start_highlight = ColorRect.new()
	start_highlight.size = Vector2(CELL_SIZE, CELL_SIZE)
	start_highlight.position = Vector2(1 * CELL_SIZE, 1 * CELL_SIZE)
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
			if next.x >= 0 and next.x < MAZE_WIDTH and next.y >= 0 and next.y < MAZE_HEIGHT:
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
			if next.x >= 0 and next.x < MAZE_WIDTH and next.y >= 0 and next.y < MAZE_HEIGHT:
				if maze[next.y][next.x] == Cell.FLOOR and not visited.has(next):
					visited[next] = true
					queue.append(next)

	return reachable

# ============ ANSWER PLACEMENT ============

func _place_answers():
	# Clear existing collectibles
	for child in $CollectibleLayer.get_children():
		child.queue_free()

	var correct_positions: Array = []
	var used_positions: Array = []
	var start_pos = Vector2i(1, 1)

	# Step 1: Place correct answers ensuring a valid path exists
	# We need to find positions such that: start -> correct1 -> correct2 -> ... -> correctN
	var current_pos = start_pos

	for q_index in range(questions.size()):
		# Get all reachable positions from current location
		var reachable = _get_reachable_positions(current_pos, used_positions)

		# Filter positions and score them for minimal backtracking
		var valid_positions: Array = []
		for pos in reachable:
			if not (pos.x <= 3 and pos.y <= 3):  # Not in start area
				# Check that we can actually reach this position
				var path = _find_path(current_pos, pos)
				if path.size() > 0:
					# Score based on distance from START (not current position)
					# This encourages forward progression through the maze
					var dist_from_start = abs(pos.x - start_pos.x) + abs(pos.y - start_pos.y)
					valid_positions.append({"pos": pos, "score": dist_from_start})

		if valid_positions.size() == 0:
			push_error("Cannot find valid position for correct answer " + str(q_index))
			continue

		# Sort by distance from start (prefer positions farther from start)
		# This reduces backtracking by creating a progressive path through the maze
		valid_positions.sort_custom(func(a, b):
			return a.score > b.score  # Higher score (farther from start) first
		)

		# Pick from the top 30% (farthest from start) with some randomness
		var pick_range = max(1, int(valid_positions.size() * 0.3))
		var chosen_data = valid_positions[randi_range(0, pick_range - 1)]
		var chosen_pos = chosen_data.pos

		correct_positions.append(chosen_pos)
		used_positions.append(chosen_pos)
		current_pos = chosen_pos

	# Step 2: Build the complete solution path (protected path through all correct answers)
	solution_path = []
	var path_cells: Dictionary = {}  # For fast lookup

	var from = start_pos
	for correct_pos in correct_positions:
		var path = _find_path(from, correct_pos)
		if path.size() == 0:
			push_error("Path verification failed")
			_regenerate_and_retry()
			return

		# Add all cells in this path segment to solution path
		for cell in path:
			if not path_cells.has(cell):
				solution_path.append(cell)
				path_cells[cell] = true

		from = correct_pos

	# Step 3: Place correct answer collectibles
	for q_index in range(questions.size()):
		var q = questions[q_index]
		_spawn_collectible(correct_positions[q_index], q.correct, q_index, true)

	# Step 4: Place wrong answers ONLY in positions that are:
	# - Not on the solution path
	# - Not adjacent to the solution path (to avoid accidental collection)
	var safe_positions: Array = []
	for y in range(MAZE_HEIGHT):
		for x in range(MAZE_WIDTH):
			if maze[y][x] == Cell.FLOOR:
				var pos = Vector2i(x, y)

				# Skip if already used or in start area
				if used_positions.has(pos) or (x <= 3 and y <= 3):
					continue

				# Skip if on solution path
				if path_cells.has(pos):
					continue

				# Skip if adjacent to solution path (prevents accidental collection)
				var adjacent_to_path = false
				for dx in [-1, 0, 1]:
					for dy in [-1, 0, 1]:
						if dx == 0 and dy == 0:
							continue
						var check_pos = Vector2i(x + dx, y + dy)
						if path_cells.has(check_pos):
							adjacent_to_path = true
							break
					if adjacent_to_path:
						break

				if not adjacent_to_path:
					safe_positions.append(pos)

	safe_positions.shuffle()
	var safe_index = 0

	# Place wrong answers in safe positions
	for q_index in range(questions.size()):
		var q = questions[q_index]
		# Place 2 wrong answers per question
		for i in range(min(2, q.wrong.size())):
			if safe_index < safe_positions.size():
				var pos = safe_positions[safe_index]
				_spawn_collectible(pos, q.wrong[i], q_index, false)
				used_positions.append(pos)
				safe_index += 1

func _regenerate_and_retry():
	# If placement fails, regenerate the maze and try again
	regeneration_attempts += 1
	if regeneration_attempts > MAX_REGENERATION_ATTEMPTS:
		push_error("Failed to generate solvable maze after max attempts")
		return

	print("Regenerating maze for valid path (attempt ", regeneration_attempts, ")...")
	_generate_maze()
	_draw_maze()
	_place_answers()

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
	player.position = Vector2(1 * CELL_SIZE + CELL_SIZE / 2, 1 * CELL_SIZE + CELL_SIZE / 2)
	player.cell_size = CELL_SIZE
	player.maze_width = MAZE_WIDTH
	player.maze_height = MAZE_HEIGHT
	player.z_index = 10  # Render on top of maze tiles
	player.set_maze(maze)
	var cols = maze[0].size() if maze.size() > 0 else 0
	print("DEBUG: Player maze set, size: ", maze.size(), " x ", cols)

# ============ GAME LOGIC ============

func _on_answer_collected(_answer_text: String, question_index: int, is_correct: bool):
	if not game_active:
		return

	# Check if this is the answer for the CURRENT question
	if question_index == current_question_index and is_correct:
		# Correct answer for current question!
		score += 100
		answers_collected += 1
		current_question_index += 1
		_flash_screen(Color(0.2, 0.8, 0.2, 0.3))
		_show_feedback("Correct!", Color(0.2, 0.8, 0.2))

		if current_question_index >= questions.size():
			# All questions answered!
			_end_game(true)
	elif question_index != current_question_index and is_correct:
		# Correct answer but WRONG order - penalty
		health -= 1
		_flash_screen(Color(0.8, 0.6, 0.2, 0.4))
		_show_feedback("Wrong order!", Color(0.8, 0.6, 0.2))
		_check_game_over()
	else:
		# Wrong answer - penalty
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

	# Emit signal after delay
	await get_tree().create_timer(2.0).timeout
	emit_signal("game_finished", success, score)
	queue_free()

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
