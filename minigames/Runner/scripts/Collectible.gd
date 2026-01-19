extends Node2D

signal collected

var answer_text: String = "Correct"
var float_time: float = 0.0
var sparkle_time: float = 0.0

func _ready():
	# Set the answer text
	if has_node("AnswerLabel"):
		$AnswerLabel.text = answer_text

	float_time = randf() * TAU

func _process(delta):
	# Floating animation
	float_time += delta * 4
	if has_node("Visual"):
		$Visual.position.y = sin(float_time) * 5

	# Gentle scale pulse
	var pulse = 1.0 + 0.05 * sin(float_time * 1.5)
	scale = Vector2(pulse, pulse)

	# Sparkle effect
	sparkle_time += delta
	if has_node("Sparkle") and sparkle_time > 0.3:
		sparkle_time = 0.0
		_create_sparkle()

func _create_sparkle():
	if not has_node("Sparkle"):
		return

	var sparkle = $Sparkle.duplicate()
	sparkle.position = Vector2(randf_range(-20, 20), randf_range(-20, 20))
	sparkle.modulate.a = 1.0
	add_child(sparkle)

	var tween = create_tween()
	tween.tween_property(sparkle, "modulate:a", 0.0, 0.4)
	tween.tween_property(sparkle, "scale", Vector2(0.1, 0.1), 0.4)
	tween.tween_callback(sparkle.queue_free)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		_collect(body.get_parent())

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		_collect(area.get_parent())

func _collect(player):
	if player.has_method("collect_effect"):
		player.collect_effect()

	collected.emit()
	_collect_effect()

func _collect_effect():
	# Prevent further collisions
	if has_node("Area2D"):
		$Area2D.set_deferred("monitoring", false)

	# Fly up and disappear effect
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 50, 0.3)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.15)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
