# ============================================
# FILE 2: level_up_scene.gd
# Save as: res://scenes/ui/level_up_scene.gd
# Attach this to the root CanvasLayer of level_up_scene.tscn
# ============================================

extends CanvasLayer

signal level_up_finished

# Node references (adjust paths based on your scene structure)
@onready var background = $Background
@onready var container = $CenterContainer/VBoxContainer
@onready var star_label = $CenterContainer/VBoxContainer/StarLabel
@onready var level_label = $CenterContainer/VBoxContainer/LevelLabel
@onready var ability_name_label = $CenterContainer/VBoxContainer/AbilityName
@onready var ability_desc_label = $CenterContainer/VBoxContainer/AbilityDesc
@onready var continue_label = $CenterContainer/VBoxContainer/ContinueLabel
@onready var animation_player = $AnimationPlayer

var can_close = false

func _ready():
	# Don't use hide() on CanvasLayer, control visibility through children
	if background:
		background.modulate.a = 0
	if container:
		container.modulate.a = 0
	# Make sure input isn't processed until ready
	set_process_input(false)

func show_level_up(old_level: int, new_level: int, ability: Dictionary):
	# Set text content
	level_label.text = "Level %d → %d" % [old_level, new_level]
	
	if ability.is_empty():
		ability_name_label.text = "Level Up!"
		ability_desc_label.text = "You've grown stronger!"
	else:
		var icon = ability.get("icon", "")
		ability_name_label.text = "%s %s" % [icon, ability.get("name", "New Ability")]
		ability_desc_label.text = ability.get("desc", "")
	
	# Special styling for max level
	if new_level == 10:
		star_label.text = "★★★ MAXIMUM LEVEL ★★★"
		ability_name_label.add_theme_color_override("font_color", Color.GOLD)
	else:
		star_label.text = "★ LEVEL UP ★"
	
	# Fade in animation
	if background and container:
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(background, "modulate:a", 1.0, 0.3)
		tween.tween_property(container, "modulate:a", 1.0, 0.5).set_ease(Tween.EASE_OUT)
		await tween.finished
	
	# Play animation if available
	if animation_player and animation_player.has_animation("level_up"):
		animation_player.play("level_up")
	
	# Wait a moment before allowing close
	await get_tree().create_timer(0.5).timeout
	can_close = true
	set_process_input(true)
	
	# Make continue label blink
	if continue_label:
		blink_continue_label()

func blink_continue_label():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(continue_label, "modulate:a", 0.3, 0.8)
	tween.tween_property(continue_label, "modulate:a", 1.0, 0.8)

func _input(event):
	if can_close and event.is_pressed():
		close_level_up()
		get_viewport().set_input_as_handled()

func close_level_up():
	can_close = false
	set_process_input(false)
	
	# Fade out animation - fade the children, not the CanvasLayer
	if background and container:
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(background, "modulate:a", 0.0, 0.3)
		tween.tween_property(container, "modulate:a", 0.0, 0.3)
		await tween.finished
	
	level_up_finished.emit()
