extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Signal handling is now managed by the DialogicSignalHandler autoload
	# No need to connect signals here anymore

	print("DEBUG: node_2d.gd is running. Starting c1s1.")
	Dialogic.start("c1s1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
