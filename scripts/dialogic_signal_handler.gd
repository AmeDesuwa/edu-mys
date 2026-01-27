extends Node

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument: String):
	print("DEBUG: Signal received: ", argument)

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

	# Handle textbox visibility
	if argument == "hide_textbox":
		Dialogic.Text.hide_textbox(true)
		return
	if argument == "show_textbox":
		Dialogic.Text.show_textbox(true)
		return

	# Handle title card signals: "show_title_card <chapter_number>"
	if argument.begins_with("show_title_card "):
		var chapter = argument.trim_prefix("show_title_card ").strip_edges()
		_handle_title_card_signal(chapter)
		return

func _handle_level_up_signal():
	Dialogic.paused = true
	var conrad_level = Dialogic.VAR.conrad_level
	await LevelUpManager.show_level_up(conrad_level)
	Dialogic.paused = false

func _handle_minigame_signal(puzzle_id: String):
	Dialogic.paused = true
	MinigameManager.start_minigame(puzzle_id)
	await MinigameManager.minigame_completed
	# Safety check: ensure Dialogic is still valid before resuming
	if is_instance_valid(Dialogic) and Dialogic.current_timeline != null:
		Dialogic.paused = false
	else:
		push_warning("Dialogic timeline was cleared during minigame, skipping resume")

func _handle_check_level_up():
	if Dialogic.VAR.minigames_completed >= 3 and Dialogic.VAR.conrad_level < 2:
		Dialogic.paused = true
		Dialogic.VAR.conrad_level = 2
		await LevelUpManager.show_level_up(2)
		Dialogic.paused = false

func _handle_title_card_signal(chapter: String):
	Dialogic.paused = true
	# Update current chapter for curriculum question selection
	Dialogic.VAR.current_chapter = int(chapter)
	TitleCardManager.show_chapter_title(chapter)
	await TitleCardManager.title_card_completed
	if is_instance_valid(Dialogic) and Dialogic.current_timeline != null:
		Dialogic.paused = false
