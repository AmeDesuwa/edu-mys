extends Node2D

signal hit_player

var answer_text: String = "Wrong"
var rotation_speed: float = 2.0
var wobble_time: float = 0.0

func _ready():
	# Set the answer text
	if has_node("AnswerLabel"):
		$AnswerLabel.text = answer_text

	# Random starting rotation for variety
	rotation = randf_range(-0.2, 0.2)
	wobble_time = randf() * TAU

func _process(delta):
	# Gentle wobble animation
	wobble_time += delta * 3
	rotation = sin(wobble_time) * 0.1

	# Pulsing glow effect
	if has_node("Glow"):
		$Glow.modulate.a = 0.3 + 0.2 * sin(wobble_time * 2)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		var player = body.get_parent()
		if player.has_method("take_damage"):
			if player.take_damage():
				hit_player.emit()
				_destroy_effect()

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		var player = area.get_parent()
		if player.has_method("take_damage"):
			if player.take_damage():
				hit_player.emit()
				_destroy_effect()

func _destroy_effect():
	# Visual feedback before destroying
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.15)
	tween.tween_property(self, "modulate:a", 0.0, 0.15)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
