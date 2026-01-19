# Enemy.gd - Ghost AI with distinct personalities
extends CharacterBody2D

signal eaten()

# Ghost personality types
enum GhostType { BLINKY, PINKY, INKY, CLYDE }

# AI modes
enum AIMode { CHASE, SCATTER, FRIGHTENED }

@export var ghost_type: GhostType = GhostType.BLINKY
@export var chase_speed = 120.0
@export var scatter_speed = 100.0
@export var frightened_speed = 60.0

var player_position = Vector2.ZERO
var player_direction = Vector2.ZERO
var blinky_position = Vector2.ZERO  # For Inky's targeting
var current_mode: AIMode = AIMode.SCATTER
var scatter_corner = Vector2.ZERO
var home_position = Vector2.ZERO

# Mode timing
var mode_timer = 0.0
var scatter_duration = 7.0
var chase_duration = 20.0
var frightened_duration = 6.0
var mode_wave = 0  # Track which scatter/chase wave we're in

# Movement
var current_target = Vector2.ZERO
var wander_timer = 0.0

# Visual
var base_color = Color.RED
var frightened_color = Color(0.2, 0.2, 1.0)  # Blue when frightened

# Initialization flag - setup happens after ghost_type is set
var _initialized = false

func _ready():
	$Area2D.add_to_group("enemy")
	home_position = position

# Call this after setting ghost_type, or it will be called automatically
func initialize():
	if _initialized:
		return
	_initialized = true
	_setup_ghost_personality()
	_start_scatter_mode()

func _setup_ghost_personality():
	var screen_size = get_viewport_rect().size

	match ghost_type:
		GhostType.BLINKY:
			# Red - Direct chaser, top-right corner
			base_color = Color(0.9, 0.2, 0.2)
			scatter_corner = Vector2(screen_size.x - 50, 50)
		GhostType.PINKY:
			# Pink - Ambusher, top-left corner
			base_color = Color(1.0, 0.7, 0.8)
			scatter_corner = Vector2(50, 50)
		GhostType.INKY:
			# Cyan - Flanker, bottom-right corner
			base_color = Color(0.3, 0.9, 0.9)
			scatter_corner = Vector2(screen_size.x - 50, screen_size.y - 50)
		GhostType.CLYDE:
			# Orange - Unpredictable, bottom-left corner
			base_color = Color(1.0, 0.6, 0.2)
			scatter_corner = Vector2(50, screen_size.y - 50)

	# Also update the body color in the scene
	if has_node("Body"):
		$Body.color = base_color
	if has_node("Glow"):
		$Glow.color = Color(base_color.r, base_color.g, base_color.b, 0.25)

	_update_visual()

func _update_visual():
	if current_mode == AIMode.FRIGHTENED:
		if has_node("Body"):
			$Body.color = frightened_color
		if has_node("Glow"):
			$Glow.color = Color(frightened_color.r, frightened_color.g, frightened_color.b, 0.25)
		# Make eyes look scared (centered)
		if has_node("LeftPupil") and has_node("RightPupil"):
			$LeftPupil.position = Vector2(-9, -4)
			$RightPupil.position = Vector2(9, -4)
	else:
		if has_node("Body"):
			$Body.color = base_color
		if has_node("Glow"):
			$Glow.color = Color(base_color.r, base_color.g, base_color.b, 0.25)
		_update_eye_direction()

func _update_eye_direction():
	if not has_node("LeftPupil") or not has_node("RightPupil"):
		return

	var look_dir = Vector2.ZERO
	if current_target != Vector2.ZERO:
		look_dir = (current_target - position).normalized()
	var pupil_offset = look_dir * 2
	$LeftPupil.position = Vector2(-9, -4) + pupil_offset
	$RightPupil.position = Vector2(9, -4) + pupil_offset

func _physics_process(delta):
	# Auto-initialize on first frame if not done yet
	if not _initialized:
		initialize()

	_update_mode_timer(delta)
	_calculate_target()
	_move_toward_target()
	_update_eye_direction()

func _update_mode_timer(delta):
	if current_mode == AIMode.FRIGHTENED:
		mode_timer -= delta
		if mode_timer <= 0:
			_end_frightened_mode()
		elif mode_timer <= 2.0:
			# Flash when about to end
			var flash = fmod(mode_timer, 0.3) < 0.15
			if has_node("Body"):
				$Body.color = frightened_color if flash else base_color
	else:
		mode_timer -= delta
		if mode_timer <= 0:
			_toggle_chase_scatter()

func _toggle_chase_scatter():
	if current_mode == AIMode.CHASE:
		_start_scatter_mode()
	else:
		_start_chase_mode()

func _start_scatter_mode():
	current_mode = AIMode.SCATTER
	# Scatter duration decreases over waves
	mode_timer = max(scatter_duration - mode_wave, 3.0)
	_update_visual()

func _start_chase_mode():
	current_mode = AIMode.CHASE
	mode_timer = chase_duration
	mode_wave += 1
	_update_visual()

func start_frightened_mode(duration: float = 6.0):
	current_mode = AIMode.FRIGHTENED
	mode_timer = duration
	frightened_duration = duration
	_update_visual()

func _end_frightened_mode():
	# Return to previous mode (chase by default after frightened)
	_start_chase_mode()

func _calculate_target():
	var screen_size = get_viewport_rect().size

	match current_mode:
		AIMode.SCATTER:
			current_target = scatter_corner
		AIMode.FRIGHTENED:
			# Random wandering
			wander_timer -= get_physics_process_delta_time()
			if wander_timer <= 0:
				current_target = Vector2(
					randf_range(100, screen_size.x - 100),
					randf_range(100, screen_size.y - 100)
				)
				wander_timer = randf_range(1.0, 2.5)
		AIMode.CHASE:
			_calculate_chase_target()

func _calculate_chase_target():
	# Don't chase if player position not set
	if player_position == Vector2.ZERO:
		return

	match ghost_type:
		GhostType.BLINKY:
			# Direct chase - target player's exact position
			current_target = player_position

		GhostType.PINKY:
			# Ambush - target 4 tiles (80 pixels) ahead of player
			var ahead = player_position + player_direction * 80
			# Clamp to screen
			var screen_size = get_viewport_rect().size
			ahead.x = clamp(ahead.x, 50, screen_size.x - 50)
			ahead.y = clamp(ahead.y, 50, screen_size.y - 50)
			current_target = ahead

		GhostType.INKY:
			# Flanking - uses Blinky's position for complex targeting
			if blinky_position == Vector2.ZERO:
				# Fallback to direct chase if no Blinky reference
				current_target = player_position
			else:
				var ahead_of_player = player_position + player_direction * 40
				var vector_from_blinky = ahead_of_player - blinky_position
				current_target = ahead_of_player + vector_from_blinky
				# Clamp to screen
				var screen_size = get_viewport_rect().size
				current_target.x = clamp(current_target.x, 50, screen_size.x - 50)
				current_target.y = clamp(current_target.y, 50, screen_size.y - 50)

		GhostType.CLYDE:
			# Unpredictable - chase when far, retreat when close
			var distance_to_player = position.distance_to(player_position)
			if distance_to_player > 150:  # Far away - chase
				current_target = player_position
			else:  # Close - retreat to corner
				current_target = scatter_corner

func _move_toward_target():
	if current_target == Vector2.ZERO:
		return

	var speed = chase_speed
	match current_mode:
		AIMode.SCATTER:
			speed = scatter_speed
		AIMode.FRIGHTENED:
			speed = frightened_speed
		AIMode.CHASE:
			speed = chase_speed

	var direction = (current_target - position).normalized()
	velocity = direction * speed
	move_and_slide()

	# Keep in screen bounds
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 30, screen_size.x - 30)
	position.y = clamp(position.y, 30, screen_size.y - 30)

func is_frightened() -> bool:
	return current_mode == AIMode.FRIGHTENED

func get_eaten():
	# Return to home position
	position = home_position
	mode_wave = 0  # Reset wave counter
	_start_scatter_mode()
	eaten.emit()
