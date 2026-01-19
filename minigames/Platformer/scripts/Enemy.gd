extends CharacterBody2D

signal hit_player
signal stomped

const SPEED = 80.0
const GRAVITY = 800.0

var direction: int = 1
var patrol_distance: float = 100.0
var start_x: float = 0.0
var is_dead: bool = false

func _ready():
	start_x = position.x
	add_to_group("enemy")

func _physics_process(delta):
	if is_dead:
		return

	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

	# Patrol movement
	velocity.x = direction * SPEED

	# Reverse at patrol bounds or walls
	if is_on_wall():
		direction *= -1
	elif abs(position.x - start_x) > patrol_distance:
		direction *= -1

	move_and_slide()

	# Update visual direction
	if has_node("Visual"):
		$Visual.scale.x = direction

	# Animate
	if has_node("Visual"):
		$Visual.position.y = sin(Time.get_ticks_msec() * 0.01) * 2

func _on_hitbox_body_entered(body):
	if is_dead:
		return

	if body.is_in_group("player"):
		# Check if player is stomping (coming from above)
		if body.velocity.y > 0 and body.position.y < position.y - 10:
			_get_stomped(body)
		else:
			# Player takes damage
			hit_player.emit()

func _get_stomped(player):
	is_dead = true
	stomped.emit()

	# Bounce the player
	if player.has_method("_physics_process"):
		player.velocity.y = -300

	# Squash animation
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 0.2), 0.15)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)
