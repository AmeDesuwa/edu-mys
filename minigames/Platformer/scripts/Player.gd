extends CharacterBody2D

# Movement constants
const SPEED = 250.0
const JUMP_VELOCITY = -450.0
const GRAVITY = 1200.0
const MAX_FALL_SPEED = 600.0

# Animation
var facing_right: bool = true
var is_jumping: bool = false
var squash_stretch: Vector2 = Vector2.ONE

# Invincibility
var is_invincible: bool = false
var invincible_timer: float = 0.0
const INVINCIBLE_DURATION = 1.5

func _ready():
	add_to_group("player")

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
		is_jumping = true
	else:
		if is_jumping:
			# Landing squash
			_apply_squash(Vector2(1.2, 0.8))
		is_jumping = false

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		# Jump stretch
		_apply_squash(Vector2(0.8, 1.3))

	# Handle horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		facing_right = direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.2)

	move_and_slide()

	# Update visuals
	_update_visuals(delta)

	# Invincibility timer
	if is_invincible:
		invincible_timer -= delta
		if invincible_timer <= 0:
			is_invincible = false
			modulate.a = 1.0
		else:
			modulate.a = 0.5 + 0.5 * sin(invincible_timer * 20)

	# Check for falling off screen
	if position.y > 700:
		var main = get_parent().get_parent()
		if main.has_method("_on_enemy_hit"):
			main._on_enemy_hit()
		position = Vector2(100, 520)  # Respawn on starting platform
		velocity = Vector2.ZERO

func _apply_squash(target: Vector2):
	squash_stretch = target

func _update_visuals(delta):
	# Smooth squash/stretch back to normal
	squash_stretch = squash_stretch.lerp(Vector2.ONE, 10 * delta)

	if has_node("Visual"):
		$Visual.scale = squash_stretch
		$Visual.scale.x *= 1 if facing_right else -1

	# Running animation (bob)
	if is_on_floor() and abs(velocity.x) > 10:
		if has_node("Visual"):
			$Visual.position.y = sin(Time.get_ticks_msec() * 0.02) * 2

func take_damage():
	if is_invincible:
		return

	is_invincible = true
	invincible_timer = INVINCIBLE_DURATION

	# Knockback
	velocity.y = -200
	velocity.x = -100 if facing_right else 100

	# Hit effect
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.3, 0.7), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.15)

func collect_effect():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
