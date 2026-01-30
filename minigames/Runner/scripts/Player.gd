extends Node2D

# Lane management
var current_lane: int = 1  # Start in middle lane (0, 1, 2)
var lane_positions: Array = []
var target_x: float = 0.0
var move_speed: float = 800.0

# Animation
var bob_time: float = 0.0
var is_moving: bool = false

# Invincibility after hit
var invincible: bool = false
var invincible_timer: float = 0.0
var invincible_duration: float = 1.5

func _ready():
	# Add to player group for collision detection
	if has_node("Area2D"):
		$Area2D.add_to_group("player")

	# Get lane positions from parent
	var main = get_parent().get_parent()
	if main.has_node("") and main.get("lane_positions"):
		lane_positions = main.lane_positions.duplicate()
	else:
		# Fallback - calculate based on screen width
		var screen_width = get_viewport_rect().size.x
		var lane_width = screen_width / 3
		lane_positions = [lane_width / 2, screen_width / 2, screen_width - lane_width / 2]

	# Set initial position
	current_lane = 1
	if lane_positions.size() > current_lane:
		position.x = lane_positions[current_lane]
		target_x = position.x

func _process(delta):
	# Handle input
	if Input.is_action_just_pressed("ui_left"):
		_move_to_lane(current_lane - 1)
	elif Input.is_action_just_pressed("ui_right"):
		_move_to_lane(current_lane + 1)

	# Smooth movement to target lane
	if abs(position.x - target_x) > 1:
		is_moving = true
		position.x = lerp(position.x, target_x, move_speed * delta / 100)

		# Tilt while moving
		var tilt_direction = sign(target_x - position.x)
		rotation = lerp(rotation, tilt_direction * 0.15, 10 * delta)
	else:
		is_moving = false
		position.x = target_x
		rotation = lerp(rotation, 0.0, 10 * delta)

	# Running bob animation
	bob_time += delta * 15
	if has_node("Visual"):
		$Visual.position.y = sin(bob_time) * 3

	# Invincibility timer
	if invincible:
		invincible_timer -= delta
		if invincible_timer <= 0:
			invincible = false
			modulate.a = 1.0
		else:
			# Flashing effect
			modulate.a = 0.5 + 0.5 * sin(invincible_timer * 20)

func _move_to_lane(new_lane: int):
	if new_lane < 0 or new_lane >= lane_positions.size():
		return

	current_lane = new_lane
	target_x = lane_positions[current_lane]

	# Play swipe sound or effect here if desired

func take_damage():
	if invincible:
		return false

	invincible = true
	invincible_timer = invincible_duration

	# Hit reaction
	_hit_reaction()
	return true

func _hit_reaction():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.3, 0.7), 0.1)
	tween.tween_property(self, "scale", Vector2(0.9, 1.1), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func collect_effect():
	# Happy bounce effect
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15).set_ease(Tween.EASE_OUT)
