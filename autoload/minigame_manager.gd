extends Node

signal minigame_completed(puzzle_id: String, success: bool)

var minigame_scene = preload("res://minigames/Drag/scenes/FillInTheBlank.tscn")
var current_minigame = null

var puzzle_configs = {
	"timeline_deduction": {
		"sentence_parts": ["The sabotage happened ", ", but was only ", " this morning."],
		"answers": ["yesterday", "discovered"],
		"choices": ["yesterday", "today", "discovered", "reported", "hidden", "leaked", "morning", "night"]
	},
	"evidence_analysis": {
		"sentence_parts": ["Someone ", " the AC tube and ", " their bracelet behind."],
		"answers": ["cut", "left"],
		"choices": ["cut", "broke", "left", "dropped", "fixed", "found", "took", "hid"]
	},
	"statement_analysis": {
		"sentence_parts": ["Greg's phone ", " at 9 PM, proving he was ", " the faculty room."],
		"answers": ["connected", "inside"],
		"choices": ["connected", "disconnected", "inside", "outside", "near", "leaving", "entering", "passing"]
	}
}

func start_minigame(puzzle_id: String) -> void:
	if current_minigame:
		push_warning("Minigame already active!")
		return
	if not puzzle_configs.has(puzzle_id):
		push_error("Unknown puzzle: " + puzzle_id)
		return

	current_minigame = minigame_scene.instantiate()
	get_tree().root.add_child(current_minigame)
	current_minigame.configure_puzzle(puzzle_configs[puzzle_id])
	current_minigame.game_finished.connect(_on_minigame_finished.bind(puzzle_id))

func _on_minigame_finished(success: bool, puzzle_id: String) -> void:
	if success:
		Dialogic.VAR.minigames_completed += 1
	minigame_completed.emit(puzzle_id, success)
	current_minigame = null
