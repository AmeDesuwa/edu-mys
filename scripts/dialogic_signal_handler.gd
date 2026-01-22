extends Node

var laya_overlay: ColorRect = null

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	_create_laya_overlay()

func _create_laya_overlay():
	# Create a dark overlay for Laya conversations
	laya_overlay = ColorRect.new()
	laya_overlay.color = Color(0, 0, 0.1, 0.4)  # Dark blue tint
	laya_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	laya_overlay.visible = false
	laya_overlay.z_index = 50  # Above background, below UI
	# Make it cover the full screen
	laya_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	get_tree().root.call_deferred("add_child", laya_overlay)

func _on_dialogic_signal(argument: String):
	print("DEBUG: Signal received: ", argument)

	# Handle Laya conversation overlay
	if argument == "laya_conversation_start":
		_show_laya_overlay()
		return

	if argument == "laya_conversation_end":
		_hide_laya_overlay()
		return

	# Handle level up signal
	if argument == "show_level_up":
		_handle_level_up_signal()
		return

	# Handle minigame signals: "start_minigame <puzzle_id>"
	if argument.begins_with("start_minigame "):
		var puzzle_id = argument.trim_prefix("start_minigame ").strip_edges()
		print("DEBUG: Starting minigame: ", puzzle_id)
		_handle_minigame_signal(puzzle_id)
		return

	# Handle level up check after all minigames complete
	if argument == "check_level_up":
		_handle_check_level_up()
		return

func _show_laya_overlay():
	if laya_overlay:
		var tween = create_tween()
		laya_overlay.modulate.a = 0
		laya_overlay.visible = true
		tween.tween_property(laya_overlay, "modulate:a", 1.0, 0.3)

func _hide_laya_overlay():
	if laya_overlay:
		var tween = create_tween()
		tween.tween_property(laya_overlay, "modulate:a", 0.0, 0.3)
		tween.tween_callback(func(): laya_overlay.visible = false)

func _handle_level_up_signal():
	Dialogic.paused = true
	var conrad_level = Dialogic.VAR.conrad_level
	await LevelUpManager.show_level_up(conrad_level)
	Dialogic.paused = false

func _handle_minigame_signal(puzzle_id: String):
	Dialogic.paused = true
	MinigameManager.start_minigame(puzzle_id)
	await MinigameManager.minigame_completed
	Dialogic.paused = false

func _handle_check_level_up():
	if Dialogic.VAR.minigames_completed >= 3 and Dialogic.VAR.conrad_level < 2:
		Dialogic.paused = true
		Dialogic.VAR.conrad_level = 2
		await LevelUpManager.show_level_up(2)
		Dialogic.paused = false
