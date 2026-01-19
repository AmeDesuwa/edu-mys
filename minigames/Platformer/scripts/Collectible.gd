extends Area2D

signal collected(is_correct: bool)

var answer_text: String = ""
var is_correct_answer: bool = false
var float_time: float = 0.0
var collected_flag: bool = false

func _ready():
	float_time = randf() * TAU
	body_entered.connect(_on_body_entered)

func setup(text: String, is_correct: bool):
	answer_text = text
	is_correct_answer = is_correct

	if has_node("Label"):
		$Label.text = text

	# Set color based on correct/wrong (subtle hint)
	if has_node("Body"):
		if is_correct:
			$Body.color = Color(0.3, 0.7, 0.4, 1)  # Greenish
		else:
			$Body.color = Color(0.7, 0.4, 0.3, 1)  # Reddish

	if has_node("Glow"):
		if is_correct:
			$Glow.color = Color(0.3, 0.8, 0.4, 0.3)
		else:
			$Glow.color = Color(0.8, 0.3, 0.3, 0.3)

func _process(delta):
	# Floating animation
	float_time += delta * 3
	position.y += sin(float_time) * 0.5

	# Gentle rotation
	rotation = sin(float_time * 0.5) * 0.1

func _on_body_entered(body):
	if collected_flag:
		return

	if body.is_in_group("player"):
		collected_flag = true

		if body.has_method("collect_effect"):
			body.collect_effect()

		collected.emit(is_correct_answer)
		_collect_animation()

func _collect_animation():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.15)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_property(self, "position:y", position.y - 30, 0.2)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
