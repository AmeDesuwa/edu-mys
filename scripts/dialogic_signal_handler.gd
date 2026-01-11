# dialogic_signal_handler.gd
extends Node

func _ready():
	# Connect to Dialogic's signal event
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument: String):
	# Check if it's a level up signal
	if argument == "show_level_up":
		var conrad_level = Dialogic.VAR.conrad_level
		await LevelUpManager.show_level_up(conrad_level)
		# Signal back to Dialogic that we're done
		Dialogic.Inputs.auto_advance.emit()
