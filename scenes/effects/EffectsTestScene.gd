# EffectsTestScene.gd
# Test scene for all visual effects
extends Control

var effects: Node

@onready var button_container: VBoxContainer = $ScrollContainer/ButtonContainer

func _ready():
	# Get effects manager (assuming it's autoloaded as "Effects")
	effects = get_node("/root/Effects")
	
	if not effects:
		push_error("Effects manager not found! Make sure it's autoloaded.")
		return
	
	_create_test_buttons()

func _create_test_buttons():
	# Screen Effects
	_add_category("Screen Effects")
	_add_button("Shake (Light)", func(): effects.shake_screen(0.5, 0.5))
	_add_button("Shake (Heavy)", func(): effects.shake_screen(2.0, 1.0))
	_add_button("Flash White", func(): effects.flash_screen("white", 0.3))
	_add_button("Flash Red", func(): effects.flash_screen("red", 0.4))
	_add_button("Fade Out", func(): effects.fade_out(1.0))
	_add_button("Fade In", func(): effects.fade_in(1.0))
	
	# Tint Effects
	_add_category("Tint Effects")
	_add_button("Tint Red", func(): effects.tint_screen("red", 0.3, 0.5))
	_add_button("Tint Blue", func(): effects.tint_screen("blue", 0.3, 0.5))
	_add_button("Tint Purple", func(): effects.tint_screen("purple", 0.3, 0.5))
	_add_button("Clear Tint", func(): effects.clear_tint(0.5))
	
	# Camera Effects
	_add_category("Camera Effects")
	_add_button("Zoom In (1.5x)", func(): effects.zoom_camera(1.5, 1.0))
	_add_button("Zoom In (2x)", func(): effects.zoom_camera(2.0, 1.0))
	_add_button("Zoom Out (0.7x)", func(): effects.zoom_camera(0.7, 1.0))
	_add_button("Reset Zoom", func(): effects.reset_zoom(1.0))
	_add_button("Pan Right", func(): effects.pan_camera(Vector2(200, 0), 1.0))
	_add_button("Pan Down", func(): effects.pan_camera(Vector2(0, 150), 1.0))
	_add_button("Reset Pan", func(): effects.reset_pan(1.0))
	
	# Particle Effects
	_add_category("Particle Effects")
	_add_button("Sparkles", func(): effects.spawn_particles("sparkles", 3.0))
	_add_button("Snow", func(): effects.spawn_particles("snow", 5.0))
	_add_button("Rain", func(): effects.spawn_particles("rain", 5.0))
	_add_button("Leaves", func(): effects.spawn_particles("leaves", 4.0))
	_add_button("Hearts", func(): effects.spawn_particles("hearts", 3.0))
	_add_button("Stars", func(): effects.spawn_particles("stars", 3.0))
	_add_button("Stop Particles", func(): effects.stop_particles())
	
	# Special Effects
	_add_category("Special Effects")
	_add_button("Glitch (Light)", func(): effects.glitch_effect(0.5, 0.5))
	_add_button("Glitch (Heavy)", func(): effects.glitch_effect(2.0, 1.0))
	_add_button("Vignette", func(): effects.vignette_effect(0.6, 1.0))
	_add_button("Clear Vignette", func(): effects.clear_vignette())
	
	# Combo Effects
	_add_category("Combo Effects")
	_add_button("Earthquake", _test_earthquake)
	_add_button("Magic Spell", _test_magic)
	_add_button("Victory", _test_victory)
	_add_button("Horror", _test_horror)
	
	# Emotion Indicators
	_add_category("Emotion Indicators")
	_add_button("Setup Character Positions", _setup_test_characters)
	_add_button("Happy", func(): effects.show_emotion("left", "happy", 2.0))
	_add_button("Love", func(): effects.show_emotion("center", "love", 2.5))
	_add_button("Angry", func(): effects.show_emotion("right", "angry", 2.0))
	_add_button("Sad", func(): effects.show_emotion("left", "sad", 2.0))
	_add_button("Surprised", func(): effects.show_emotion("center", "shocked", 2.0))
	_add_button("Nervous", func(): effects.show_emotion("right", "sweat", 2.0))
	_add_button("Question", func(): effects.show_emotion("left", "question", 2.0))
	_add_button("Idea", func(): effects.show_emotion("center", "idea", 2.5))
	_add_button("Embarrassed", func(): effects.show_emotion("right", "blush", 2.0))
	_add_button("Multiple Emotions", _test_multiple_emotions)

func _add_category(title: String):
	var label = Label.new()
	label.text = "
" + title
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", Color.YELLOW)
	button_container.add_child(label)

func _add_button(text: String, callback: Callable):
	var button = Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(200, 40)
	button.pressed.connect(callback)
	button_container.add_child(button)

# Combo effect tests
func _test_earthquake():
	effects.shake_screen(2.0, 3.0)
	effects.spawn_particles("leaves", 3.0)
	effects.tint_screen("orange", 0.2, 1.0)
	await get_tree().create_timer(3.0).timeout
	effects.clear_tint(1.0)

func _test_magic():
	effects.flash_screen("cyan", 0.3)
	effects.spawn_particles("sparkles", 3.0)
	effects.zoom_camera(1.3, 1.0)
	effects.tint_screen("purple", 0.2, 1.0)
	await get_tree().create_timer(3.0).timeout
	effects.clear_tint(1.0)
	effects.reset_zoom(1.0)

func _test_victory():
	effects.flash_screen("yellow", 0.3)
	effects.spawn_particles("stars", 3.0)
	effects.zoom_camera(1.4, 1.0)
	await get_tree().create_timer(3.0).timeout
	effects.reset_zoom(1.0)

func _test_horror():
	effects.tint_screen("red", 0.4, 1.5)
	effects.vignette_effect(0.7, 1.5)
	effects.shake_screen(0.5, 2.0)
	await get_tree().create_timer(3.0).timeout
	effects.clear_tint(1.0)
	effects.clear_vignette()

# Emotion test functions
func _setup_test_characters():
	# Setup three character positions (left, center, right)
	var viewport_width = get_viewport().get_visible_rect().size.x
	effects.set_character_position("left", Vector2(viewport_width * 0.25, 200))
	effects.set_character_position("center", Vector2(viewport_width * 0.5, 200))
	effects.set_character_position("right", Vector2(viewport_width * 0.75, 200))
	print("Character positions set up!")

func _test_multiple_emotions():
	_setup_test_characters()
	await get_tree().create_timer(0.5).timeout
	effects.show_emotion("left", "happy", 3.0)
	await get_tree().create_timer(0.3).timeout
	effects.show_emotion("center", "love", 3.0)
	await get_tree().create_timer(0.3).timeout
	effects.show_emotion("right", "excited", 3.0)