# Title Card Scene
# Displays a cinematic chapter title card with background image
extends Control

signal title_card_finished

var canvas_layer: CanvasLayer
var container: Control
var background_image: TextureRect
var title_panel: ColorRect
var title_label: Label

func _ready():
	_setup_ui()

func _setup_ui():
	# Create CanvasLayer to render on top
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 50
	add_child(canvas_layer)

	# Container Control that fills the viewport
	container = Control.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.size = get_viewport().get_visible_rect().size
	canvas_layer.add_child(container)

	# Background image (full screen)
	background_image = TextureRect.new()
	background_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	background_image.anchor_right = 1.0
	background_image.anchor_bottom = 1.0
	background_image.offset_right = 0
	background_image.offset_bottom = 0
	background_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background_image.modulate.a = 0.0
	container.add_child(background_image)

	# Bottom panel for title (light blue like in the screenshot)
	title_panel = ColorRect.new()
	title_panel.color = Color(0.85, 0.9, 0.95, 1.0)  # Light blue-gray
	title_panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	title_panel.anchor_top = 1.0
	title_panel.anchor_bottom = 1.0
	title_panel.offset_top = -120
	title_panel.offset_bottom = 0
	title_panel.modulate.a = 0.0
	container.add_child(title_panel)

	# Title label (centered in panel)
	title_label = Label.new()
	title_label.text = ""
	title_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 48)
	title_label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1, 1))
	title_panel.add_child(title_label)

	# Continue indicator (>> arrows at bottom right)
	var continue_label = Label.new()
	continue_label.text = ">>"
	continue_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	continue_label.anchor_left = 1.0
	continue_label.anchor_top = 1.0
	continue_label.offset_left = -60
	continue_label.offset_top = -40
	continue_label.offset_right = -20
	continue_label.offset_bottom = -10
	continue_label.add_theme_font_size_override("font_size", 32)
	continue_label.add_theme_color_override("font_color", Color(0.3, 0.5, 0.8, 1))
	continue_label.modulate.a = 0.0
	title_panel.add_child(continue_label)

	# Store reference for animation
	set_meta("continue_label", continue_label)

	# Update container size when viewport changes
	get_viewport().size_changed.connect(_on_viewport_size_changed)

func _on_viewport_size_changed():
	if container:
		container.size = get_viewport().get_visible_rect().size

# Main function to show title card with polling for input
func show_title_card_v2(image_path: String, title_text: String) -> void:
	# Ensure container matches viewport
	container.size = get_viewport().get_visible_rect().size

	# Load and set background image
	var texture = load(image_path)
	if texture:
		background_image.texture = texture
	else:
		push_error("Failed to load title card image: " + image_path)

	title_label.text = title_text
	set_meta("input_received", false)

	# Animation sequence - fade in
	var tween = create_tween()
	tween.tween_property(background_image, "modulate:a", 1.0, 1.0).set_ease(Tween.EASE_OUT)
	tween.tween_property(title_panel, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_OUT)

	var continue_label = get_meta("continue_label")
	tween.tween_property(continue_label, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT)

	await tween.finished

	# Wait for player input (polling)
	while not get_meta("input_received"):
		await get_tree().process_frame

	# Fade out
	var fade_out = create_tween()
	fade_out.tween_property(background_image, "modulate:a", 0.0, 0.8).set_ease(Tween.EASE_IN)
	fade_out.parallel().tween_property(title_panel, "modulate:a", 0.0, 0.8).set_ease(Tween.EASE_IN)

	await fade_out.finished
	title_card_finished.emit()
	queue_free()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		set_meta("input_received", true)
	elif event is InputEventKey and event.pressed:
		set_meta("input_received", true)
