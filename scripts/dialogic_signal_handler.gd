# ============================================
# FILE 3: dialogic_signal_handler.gd
# Save as: res://scripts/dialogic_signal_handler.gd
# Attach this to your main game scene or make it an autoload
# ============================================

extends Node

func _ready():
	# Connect to Dialogic's signal event
	Dialogic.signal_event.connect(_on_dialogic_signal)

	# Connect to MinigameManager completion signal
	MinigameManager.minigame_completed.connect(_on_minigame_completed)

func _on_dialogic_signal(argument: String):
	# Check if it's a level up signal
	if argument == "show_level_up":
		var conrad_level = Dialogic.VAR.conrad_level
		await LevelUpManager.show_level_up(conrad_level)
		# Signal back to Dialogic that we're done
		Dialogic.Inputs.auto_advance.emit()

	# Check if it's a minigame signal
	elif argument.begins_with("minigame_"):
		_handle_minigame_signal(argument)

func _handle_minigame_signal(argument: String):
	# Handle different minigame triggers
	match argument:
		"minigame_witness_choice":
			# Chapter 1, Scene 1: Choosing the right witness
			var puzzle_data = {
				"sentence_parts": [
					"The best witness would be a ",
					" because they ",
					" the faculty room regularly."
				],
				"answers": ["Janitor", "clean"],
				"choices": [
					"Janitor", "Teacher", "Student", "Guard",
					"clean", "avoid", "enter", "lock"
				]
			}
			MinigameManager.start_fill_in_blank(puzzle_data)

		"minigame_timeline_deduction":
			# Chapter 1, Scene 2: Understanding the timeline
			var puzzle_data = {
				"sentence_parts": [
					"The leak was ",
					" yesterday, but only ",
					" this morning."
				],
				"answers": ["caused", "discovered"],
				"choices": [
					"caused", "fixed", "reported", "hidden",
					"discovered", "repaired", "ignored", "leaked"
				]
			}
			MinigameManager.start_fill_in_blank(puzzle_data)

		"minigame_evidence_choice":
			# Chapter 1, Scene 5: Choosing the right evidence
			var puzzle_data = {
				"sentence_parts": [
					"The most important evidence is the ",
					" because it proves Greg was ",
					" at the scene."
				],
				"answers": ["bracelet", "present"],
				"choices": [
					"bracelet", "phone", "key", "note",
					"present", "innocent", "guilty", "absent"
				]
			}
			MinigameManager.start_fill_in_blank(puzzle_data)

		_:
			push_warning("Unknown minigame signal: ", argument)

func _on_minigame_completed(success: bool, score: int):
	# Handle minigame completion
	print("DialogicSignalHandler: Minigame completed - Success: ", success, ", Score: ", score)

	# Award score to chapter score if successful
	if success:
		PlayerStats.add_score(score)
		Dialogic.VAR.chapter1_score += score
		print("Added ", score, " points. Chapter 1 score: ", Dialogic.VAR.chapter1_score)
