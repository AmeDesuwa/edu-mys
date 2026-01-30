extends Area2D

signal collected(collectible: Node, answer_text: String, question_index: int, is_correct: bool)

var answer_text: String = ""
var question_index: int = 0
var is_correct: bool = false
var is_collected: bool = false  # Prevent multiple triggers

# Animation
var bob_offset: float = 0.0
var base_y: float = 0.0

# Colors based on question index (so player can visually identify which question)
const QUESTION_COLORS = [
	Color(0.9, 0.3, 0.3),   # Q1 - Red
	Color(0.3, 0.7, 0.9),   # Q2 - Blue
	Color(0.3, 0.9, 0.4),   # Q3 - Green
	Color(0.9, 0.7, 0.2),   # Q4 - Yellow
	Color(0.8, 0.4, 0.9),   # Q5 - Purple
]

func _ready():
	base_y = position.y
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func setup(text: String, q_index: int, correct: bool):
	answer_text = text
	question_index = q_index
	is_correct = correct

	# Update visuals
	$Label.text = text

	# Color based on question number
	var color_index = q_index % QUESTION_COLORS.size()
	var base_color = QUESTION_COLORS[color_index]

	# Correct answers are brighter, wrong answers are dimmer
	if is_correct:
		$Body.color = base_color
		$Glow.color = Color(base_color.r, base_color.g, base_color.b, 0.4)
	else:
		$Body.color = base_color.darkened(0.3)
		$Glow.color = Color(base_color.r, base_color.g, base_color.b, 0.2)

	# Show question number indicator
	$QuestionNumber.text = "Q" + str(q_index + 1)

func _process(delta):
	# Gentle bobbing animation
	bob_offset += delta * 3.0
	position.y = base_y + sin(bob_offset) * 3.0

func _on_body_entered(body):
	if body.is_in_group("player") and not is_collected:
		_try_collect()

func _on_area_entered(area):
	if area.is_in_group("player") and not is_collected:
		_try_collect()

func _try_collect():
	if is_collected:
		return
	# Emit signal with our data - Main.gd will decide if we should be removed
	emit_signal("collected", self, answer_text, question_index, is_correct)

# Called by Main.gd when collection is confirmed (correct answer in correct order)
func confirm_collect():
	if is_collected:
		return
	is_collected = true

	# Collection animation
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.15)
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)

# Called by Main.gd when wrong answer is collected (remove it as penalty)
func reject_collect():
	if is_collected:
		return
	is_collected = true

	# Rejection animation (shrink and fade red)
	modulate = Color(1, 0.3, 0.3, 1)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(0.3, 0.3), 0.2)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)

# Called by Main.gd when correct answer collected in wrong order (don't remove, just shake)
func wrong_order_feedback():
	# Shake animation to indicate wrong order, but don't remove
	var original_pos = position
	var tween = create_tween()
	tween.tween_property(self, "position", original_pos + Vector2(5, 0), 0.05)
	tween.tween_property(self, "position", original_pos - Vector2(5, 0), 0.05)
	tween.tween_property(self, "position", original_pos + Vector2(5, 0), 0.05)
	tween.tween_property(self, "position", original_pos, 0.05)

	# Brief invulnerability to prevent spam
	set_deferred("monitoring", false)
	await get_tree().create_timer(0.5).timeout
	if is_instance_valid(self) and not is_collected:
		monitoring = true
