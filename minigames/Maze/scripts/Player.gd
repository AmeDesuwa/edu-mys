extends Area2D

# Movement
const MOVE_SPEED = 180.0
var cell_size: int = 26
var maze_width: int = 45
var maze_height: int = 35
var maze: Array = []

# State
var target_position: Vector2
var is_moving: bool = false

func _ready():
	add_to_group("player")
	target_position = position

func set_maze(maze_data: Array):
	maze = maze_data
	print("DEBUG Player: Received maze with ", maze.size(), " rows")

func _physics_process(delta):
	if is_moving:
		# Move toward target
		var direction = (target_position - position).normalized()
		var distance = position.distance_to(target_position)

		if distance < 5:
			position = target_position
			is_moving = false
		else:
			position += direction * MOVE_SPEED * delta
	else:
		# Check for input (arrow keys + WASD)
		var input_dir = Vector2.ZERO

		if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
			input_dir = Vector2.RIGHT
		elif Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
			input_dir = Vector2.LEFT
		elif Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
			input_dir = Vector2.DOWN
		elif Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
			input_dir = Vector2.UP

		if input_dir != Vector2.ZERO:
			_try_move(input_dir)

func _try_move(direction: Vector2):
	# Calculate current grid position
	var current_grid = Vector2i(
		int(position.x / cell_size),
		int(position.y / cell_size)
	)

	# Calculate target grid position
	var target_grid = current_grid + Vector2i(int(direction.x), int(direction.y))

	# Check bounds
	if target_grid.x < 0 or target_grid.x >= maze_width:
		print("DEBUG: Out of bounds X")
		return
	if target_grid.y < 0 or target_grid.y >= maze_height:
		print("DEBUG: Out of bounds Y")
		return

	# Check if maze data exists
	if maze.size() == 0:
		print("DEBUG: Maze is empty!")
		return

	# Check if target is floor (0 = WALL, 1 = FLOOR in the Cell enum)
	var cell_value = maze[target_grid.y][target_grid.x]
	if cell_value == 1:  # FLOOR
		# Can move!
		target_position = Vector2(
			target_grid.x * cell_size + cell_size / 2,
			target_grid.y * cell_size + cell_size / 2
		)
		is_moving = true
	else:
		print("DEBUG: Cell is wall at ", target_grid, " value=", cell_value)

func _on_area_entered(_area):
	# Collision with collectibles handled by collectible
	pass
