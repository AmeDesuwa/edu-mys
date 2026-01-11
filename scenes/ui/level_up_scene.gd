# level_up_scene.gd
# Save as: res://scenes/ui/level_up_scene.gd

extends CanvasLayer

signal level_up_finished

# Node references
@onready var animated_bg = $AnimatedBackground
@onready var level_container = $CenterContainer/LevelContainer
@onready var star_burst = $CenterContainer/LevelContainer/StarBurst
@onready var level_badge = $CenterContainer/LevelContainer/LevelBadge
@onready var level_number = $CenterContainer/LevelContainer/LevelBadge/LevelNumber
@onready var ability_panel = $CenterContainer/LevelContainer/AbilityPanel
@onready var ability_icon = $CenterContainer/LevelContainer/AbilityPanel/VBoxContainer/AbilityIcon
@onready var ability_title = $CenterContainer/LevelContainer/AbilityPanel/VBoxContainer/AbilityTitle
@onready var ability_desc = $CenterContainer/LevelContainer/AbilityPanel/VBoxContainer/AbilityDesc
@onready var new_ability_label = $CenterContainer/LevelContainer/AbilityPanel/VBoxContainer/NewAbilityLabel
@onready var tap_to_continue = $CenterContainer/LevelContainer/TapToContinue
@onready var level_up_sound = $LevelUpSound
@onready var max_level_sound = $MaxLevelSound

var can_close = false
var is_max_level = false

func _ready():
	hide()
	set_process_input(false)
	self.modulate = Color(1, 1, 1, 0)

func show_level_up(old_level: int, new_level: int, ability: Dictionary):
	is_max_level = (new_level == 10)
	
	# Set up content
	level_number.text = str(new_level)
	
	if ability.is_empty():
		ability_title.text = "LEVEL UP!"
		ability_desc.text = "You've grown stronger"
		ability_icon.text = "⭐"
	else:
		ability_icon.text = ability.get("icon", "✨")
		ability_title.text = ability.get("name", "New Ability").to_upper()
		ability_desc.text = ability.get("desc", "")
		
		# Set ability color theme
		var ability_color = ability.get("color", Color.WHITE)
		ability_panel.self_modulate = ability_color
	
	# Special max level styling
	if is_max_level:
		star_burst.text = "★★★ MAXIMUM LEVEL ACHIEVED ★★★"
		level_badge.modulate = Color.GOLD
		new_ability_label.text = "🏆 MASTERY UNLOCKED 🏆"
		if max_level_sound and max_level_sound.stream:
			max_level_sound.play()
		start_max_level_animation()
	else:
		star_burst.text = "★ LEVEL UP ★"
		new_ability_label.text = "✨ NEW ABILITY UNLOCKED ✨"
		if level_up_sound and level_up_sound.stream:
			level_up_sound.play()
		start_normal_animation()
	
	show()

func start_normal_animation():
	# Fade in entire scene
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, 0.3)
	
	# Animate background rotation
	animate_background()
	
	# Star burst scale bounce
	star_burst.scale = Vector2.ZERO
	var star_tween = create_tween()
	star_tween.set_ease(Tween.EASE_OUT)
	star_tween.set_trans(Tween.TRANS_BACK)
	star_tween.tween_property(star_burst, "scale", Vector2.ONE, 0.6)
	
	await get_tree().create_timer(0.3).timeout
	
	# Level badge pop in
	level_badge.scale = Vector2.ZERO
	level_badge.rotation = -PI
	var badge_tween = create_tween().set_parallel()
	badge_tween.set_ease(Tween.EASE_OUT)
	badge_tween.set_trans(Tween.TRANS_BACK)
	badge_tween.tween_property(level_badge, "scale", Vector2.ONE * 1.2, 0.5)
	badge_tween.tween_property(level_badge, "rotation", 0.0, 0.5)
	
	await badge_tween.finished
	
	# Badge settle to normal size
	var settle_tween = create_tween()
	settle_tween.tween_property(level_badge, "scale", Vector2.ONE, 0.2)
	
	await get_tree().create_timer(0.2).timeout
	
	# Ability panel slide up
	ability_panel.position.y = 200
	ability_panel.modulate = Color(1, 1, 1, 0)
	var panel_tween = create_tween().set_parallel()
	panel_tween.set_ease(Tween.EASE_OUT)
	panel_tween.set_trans(Tween.TRANS_CUBIC)
	panel_tween.tween_property(ability_panel, "position:y", 0.0, 0.5)
	panel_tween.tween_property(ability_panel, "modulate:a", 1.0, 0.5)
	
	await panel_tween.finished
	
	# Tap to continue blink
	start_tap_blink()
	
	# Enable input
	can_close = true
	set_process_input(true)

func start_max_level_animation():
	# Even more dramatic for max level
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
	animate_background(true)
	
	# Star burst with elastic effect
	star_burst.scale = Vector2.ZERO
	var star_tween = create_tween()
	star_tween.set_ease(Tween.EASE_OUT)
	star_tween.set_trans(Tween.TRANS_ELASTIC)
	star_tween.tween_property(star_burst, "scale", Vector2.ONE * 1.2, 1.0)
	
	await get_tree().create_timer(0.4).timeout
	
	# Level badge dramatic entrance
	level_badge.scale = Vector2.ZERO
	level_badge.rotation = PI * 2
	var badge_tween = create_tween().set_parallel()
	badge_tween.set_ease(Tween.EASE_OUT)
	badge_tween.set_trans(Tween.TRANS_ELASTIC)
	badge_tween.tween_property(level_badge, "scale", Vector2.ONE * 1.3, 0.8)
	badge_tween.tween_property(level_badge, "rotation", 0.0, 0.8)
	
	# Add continuous rotation to badge
	var rotate_tween = create_tween()
	rotate_tween.set_loops()
	rotate_tween.tween_property(level_badge, "rotation", PI * 2, 3.0)
	
	await badge_tween.finished
	
	await get_tree().create_timer(0.3).timeout
	
	# Ability panel explosive entrance
	ability_panel.position.y = 300
	ability_panel.scale = Vector2(0.5, 0.5)
	ability_panel.modulate = Color(1, 1, 1, 0)
	var panel_tween = create_tween().set_parallel()
	panel_tween.set_ease(Tween.EASE_OUT)
	panel_tween.set_trans(Tween.TRANS_BACK)
	panel_tween.tween_property(ability_panel, "position:y", 0.0, 0.6)
	panel_tween.tween_property(ability_panel, "scale", Vector2.ONE, 0.6)
	panel_tween.tween_property(ability_panel, "modulate:a", 1.0, 0.6)
	
	await panel_tween.finished
	
	start_tap_blink()
	can_close = true
	set_process_input(true)

func animate_background(intense: bool = false):
	# Animated gradient shift via rotation
	var duration = 3.0 if intense else 5.0
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(animated_bg, "rotation", PI * 2, duration)

func start_tap_blink():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(tap_to_continue, "modulate:a", 0.3, 0.8)
	tween.tween_property(tap_to_continue, "modulate:a", 1.0, 0.8)

func _input(event):
	if can_close and event.is_pressed():
		close_level_up()
		get_viewport().set_input_as_handled()

func close_level_up():
	can_close = false
	set_process_input(false)
	
	# Fade out
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	tween.tween_property(level_container, "scale", Vector2(1.2, 1.2), 0.4)
	
	await tween.finished
	level_up_finished.emit()
