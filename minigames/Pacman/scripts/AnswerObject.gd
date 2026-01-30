# AnswerObject.gd - Attach to AnswerObject scene
extends CharacterBody2D

var answer_text = ""
var is_correct = false

@export var move_speed = 80.0
var direction = Vector2.ZERO
var change_direction_timer = 0.0

# Floating animation
var base_panel_y = 0.0
var float_tween: Tween = null

func _ready():
	$Panel/Label.text = answer_text

	# Add to group for collision detection
	$Area2D.add_to_group("answer")

	# Set initial random direction
	randomize_direction()

	# Start floating animation
	_start_float_animation()

func _physics_process(delta):
	# Change direction periodically
	change_direction_timer -= delta
	if change_direction_timer <= 0:
		randomize_direction()
		change_direction_timer = randf_range(2.0, 4.0)
	
	# Move in current direction
	velocity = direction * move_speed
	move_and_slide()
	
	# Bounce off screen bounds
	var screen_size = get_viewport_rect().size
	if position.x < 40 or position.x > screen_size.x - 40:
		direction.x = -direction.x
		position.x = clamp(position.x, 40, screen_size.x - 40)
	if position.y < 40 or position.y > screen_size.y - 40:
		direction.y = -direction.y
		position.y = clamp(position.y, 40, screen_size.y - 40)

func randomize_direction():
	var angle = randf() * TAU  # Random angle in radians
	direction = Vector2(cos(angle), sin(angle)).normalized()

func _start_float_animation():
	# Subtle floating bob animation for the panel
	base_panel_y = $Panel.position.y
	_animate_float_up()

func _animate_float_up():
	if not is_instance_valid(self):
		return
	float_tween = create_tween()
	float_tween.tween_property($Panel, "position:y", base_panel_y - 3, 0.8).set_ease(Tween.EASE_IN_OUT)
	float_tween.tween_callback(_animate_float_down)

func _animate_float_down():
	if not is_instance_valid(self):
		return
	float_tween = create_tween()
	float_tween.tween_property($Panel, "position:y", base_panel_y + 3, 0.8).set_ease(Tween.EASE_IN_OUT)
	float_tween.tween_callback(_animate_float_up)
