# Enemy.gd - Ghost AI with distinct personalities and wall avoidance
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
var current_direction = Vector2.RIGHT  # Current movement direction
var last_position = Vector2.ZERO
var stuck_timer = 0.0
var direction_change_cooldown = 0.0

# Wall avoidance
var raycast_length = 50.0
var avoidance_strength = 1.5

# Dash ability
var dash_cooldown = 0.0
var dash_timer = 0.0
var is_dashing = false
var dash_direction = Vector2.ZERO
const DASH_SPEED_MULTIPLIER = 3.0
const DASH_DURATION = 0.25
const DASH_COOLDOWN_MIN = 3.0
const DASH_COOLDOWN_MAX = 6.0
const DASH_TRIGGER_DISTANCE = 200.0  # Dash when player is within this range

# Teleport ability - warp near player when too far
var teleport_cooldown = 0.0
const TELEPORT_COOLDOWN = 2.0  # Individual cooldown after teleporting
const TELEPORT_FAR_DISTANCE = 300.0  # Teleport when player is beyond this
const TELEPORT_ARRIVE_DISTANCE_MIN = 180.0  # Minimum distance to appear from player
const TELEPORT_ARRIVE_DISTANCE_MAX = 280.0  # Maximum distance to appear from player
const TELEPORT_AHEAD_DISTANCE = 150.0  # How far ahead of player to predict

# Visual
var base_color = Color.RED
var frightened_color = Color(0.2, 0.2, 1.0)  # Blue when frightened
var dash_color = Color(1.0, 1.0, 1.0)  # White flash when dashing

# Initialization flag - setup happens after ghost_type is set
var _initialized = false

func _ready():
	$Area2D.add_to_group("enemy")
	home_position = position
	last_position = position

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
	_update_cooldowns(delta)
	_calculate_target()
	_try_teleport()
	_try_dash()
	_move_with_avoidance(delta)
	_check_if_stuck(delta)
	_update_eye_direction()

func _update_cooldowns(delta):
	if direction_change_cooldown > 0:
		direction_change_cooldown -= delta
	if dash_cooldown > 0:
		dash_cooldown -= delta
	if teleport_cooldown > 0:
		teleport_cooldown -= delta
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			_end_dash()

func _check_if_stuck(delta):
	var distance_moved = position.distance_to(last_position)
	if distance_moved < 0.5:
		stuck_timer += delta
		if stuck_timer > 0.3:
			# We're stuck - try a different direction
			_unstick()
			stuck_timer = 0.0
	else:
		stuck_timer = 0.0
	last_position = position

func _unstick():
	# Try perpendicular directions or reverse
	var perpendicular = Vector2(-current_direction.y, current_direction.x)
	if randf() > 0.5:
		perpendicular = -perpendicular
	current_direction = perpendicular
	direction_change_cooldown = 0.5

func _try_dash():
	# Don't dash if on cooldown, already dashing, or frightened
	if dash_cooldown > 0 or is_dashing or current_mode == AIMode.FRIGHTENED:
		return

	# Only dash when player is within range and in chase mode
	if current_mode != AIMode.CHASE or player_position == Vector2.ZERO:
		return

	var distance_to_player = position.distance_to(player_position)
	if distance_to_player > DASH_TRIGGER_DISTANCE:
		return

	# Different ghost types have different dash behaviors
	var should_dash = false
	match ghost_type:
		GhostType.BLINKY:
			# Blinky dashes aggressively when close
			should_dash = distance_to_player < 150 and randf() < 0.4
		GhostType.PINKY:
			# Pinky dashes to cut off the player
			should_dash = randf() < 0.3
		GhostType.INKY:
			# Inky dashes unpredictably
			should_dash = randf() < 0.25
		GhostType.CLYDE:
			# Clyde rarely dashes (he's shy)
			should_dash = distance_to_player > 100 and randf() < 0.15

	if should_dash:
		_start_dash()

func _start_dash():
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_direction = (current_target - position).normalized()
	dash_cooldown = randf_range(DASH_COOLDOWN_MIN, DASH_COOLDOWN_MAX)

	# Visual feedback - flash white
	if has_node("Body"):
		$Body.color = dash_color
	if has_node("Glow"):
		$Glow.color = Color(1.0, 1.0, 1.0, 0.5)

func _end_dash():
	is_dashing = false
	_update_visual()

func _try_teleport():
	# Don't teleport if on cooldown, dashing, or frightened
	if teleport_cooldown > 0 or is_dashing or current_mode == AIMode.FRIGHTENED:
		return

	# Only teleport in chase mode when player position is known
	if current_mode != AIMode.CHASE or player_position == Vector2.ZERO:
		return

	var distance_to_player = position.distance_to(player_position)
	if distance_to_player < TELEPORT_FAR_DISTANCE:
		return

	# Check with main game if we can teleport (one at a time)
	var main = get_parent().get_parent()
	if main.has_method("request_ghost_teleport"):
		if main.request_ghost_teleport(self):
			_do_teleport()

func _do_teleport():
	var screen_size = get_viewport_rect().size

	# Predict where player is heading
	var predicted_pos = player_position
	if player_direction != Vector2.ZERO:
		predicted_pos = player_position + player_direction * TELEPORT_AHEAD_DISTANCE

	# Clamp predicted position to screen
	predicted_pos.x = clamp(predicted_pos.x, 80, screen_size.x - 80)
	predicted_pos.y = clamp(predicted_pos.y, 80, screen_size.y - 80)

	# Pick a position around the predicted location (not directly on it)
	# Favor positions ahead of and to the sides of the player
	var angle_offset = randf_range(-PI / 3, PI / 3)  # -60 to +60 degrees from player direction
	var base_angle = player_direction.angle() if player_direction != Vector2.ZERO else randf() * TAU
	var angle = base_angle + angle_offset

	# Pick a distance within the arrival range
	var distance = randf_range(TELEPORT_ARRIVE_DISTANCE_MIN, TELEPORT_ARRIVE_DISTANCE_MAX)

	# Calculate new position relative to predicted position
	var offset = Vector2(cos(angle), sin(angle)) * distance
	var new_pos = predicted_pos + offset

	# Clamp to screen bounds
	new_pos.x = clamp(new_pos.x, 50, screen_size.x - 50)
	new_pos.y = clamp(new_pos.y, 50, screen_size.y - 50)

	# Make sure we're not too close to the player's current position
	if new_pos.distance_to(player_position) < TELEPORT_ARRIVE_DISTANCE_MIN:
		# Push away from player
		var away_dir = (new_pos - player_position).normalized()
		new_pos = player_position + away_dir * TELEPORT_ARRIVE_DISTANCE_MIN

	# Visual effect - brief flash at old position
	_spawn_teleport_effect(position)

	# Teleport
	position = new_pos
	last_position = new_pos  # Reset stuck detection

	# Visual effect at new position
	_spawn_teleport_effect(position)

	# Set individual cooldown
	teleport_cooldown = TELEPORT_COOLDOWN

	# Face toward where player is heading
	current_direction = (predicted_pos - position).normalized()

func _spawn_teleport_effect(pos: Vector2):
	# Create a quick visual indicator
	var effect = Polygon2D.new()
	effect.color = Color(base_color.r, base_color.g, base_color.b, 0.7)
	effect.polygon = PackedVector2Array([
		Vector2(-15, -15), Vector2(15, -15),
		Vector2(15, 15), Vector2(-15, 15)
	])
	effect.position = pos
	get_parent().add_child(effect)

	# Fade out and remove
	var tween = get_tree().create_tween()
	tween.tween_property(effect, "scale", Vector2(2, 2), 0.3)
	tween.parallel().tween_property(effect, "modulate:a", 0.0, 0.3)
	tween.tween_callback(effect.queue_free)

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

func _move_with_avoidance(_delta):
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

	# Handle dashing - move fast in a straight line
	if is_dashing:
		speed *= DASH_SPEED_MULTIPLIER
		velocity = dash_direction * speed
		move_and_slide()
		_keep_in_bounds()
		return

	# Calculate desired direction toward target
	var desired_direction = (current_target - position).normalized()

	# Only change direction if cooldown allows
	if direction_change_cooldown <= 0:
		# Check for walls and adjust direction
		var avoidance = _calculate_wall_avoidance()
		if avoidance != Vector2.ZERO:
			desired_direction = (desired_direction + avoidance * avoidance_strength).normalized()

		# Smoothly interpolate toward desired direction
		current_direction = current_direction.lerp(desired_direction, 0.15)

	# Apply movement
	velocity = current_direction.normalized() * speed
	move_and_slide()

	_keep_in_bounds()

func _keep_in_bounds():
	# Keep in screen bounds
	var screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 30, screen_size.x - 30)
	position.y = clamp(position.y, 30, screen_size.y - 30)

func _calculate_wall_avoidance() -> Vector2:
	var avoidance = Vector2.ZERO
	var space_state = get_world_2d().direct_space_state

	# Cast rays in multiple directions to detect walls
	var ray_directions = [
		current_direction,  # Forward
		current_direction.rotated(deg_to_rad(45)),  # Forward-right
		current_direction.rotated(deg_to_rad(-45)),  # Forward-left
		current_direction.rotated(deg_to_rad(90)),  # Right
		current_direction.rotated(deg_to_rad(-90)),  # Left
	]

	for i in range(ray_directions.size()):
		var ray_dir = ray_directions[i]
		var query = PhysicsRayQueryParameters2D.create(
			position,
			position + ray_dir * raycast_length
		)
		query.exclude = [self]
		query.collision_mask = 1  # Walls layer

		var result = space_state.intersect_ray(query)
		if result:
			# Wall detected - add avoidance force away from it
			var distance = position.distance_to(result.position)
			var strength = 1.0 - (distance / raycast_length)

			# Stronger avoidance for forward rays
			if i == 0:
				strength *= 2.0

			avoidance -= ray_dir * strength

	return avoidance

func is_frightened() -> bool:
	return current_mode == AIMode.FRIGHTENED

func get_eaten():
	# Return to home position
	position = home_position
	mode_wave = 0  # Reset wave counter
	_start_scatter_mode()
	eaten.emit()
