extends Node2D

# Flag to indicate if we should load a save instead of starting fresh
static var load_continue_save := false

func _ready() -> void:
	Dialogic.paused = false

	if load_continue_save:
		# Load the saved game state
		print("DEBUG: node_2d.gd loading continue save.")
		load_continue_save = false
		# Wait for scene to be fully ready, then load save
		call_deferred("_load_save")
	else:
		# Start fresh from Chapter 1 Scene 1
		print("DEBUG: node_2d.gd starting c1s1.")
		Dialogic.start("c1s1")

func _load_save() -> void:
	# Dialogic.Save.load() handles starting the timeline from saved state
	Dialogic.Save.load("continue_save")
