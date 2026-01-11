extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the dialogic_signal to our handler function.
	Dialogic.dialogic_signal.connect(_on_dialogic_signal)
	
	print("DEBUG: node_2d.gd is running. Starting c1s3.")
	Dialogic.start("c1s3")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dialogic_signal(argument: String):
	"""
	Handles signals emitted from Dialogic timelines.
	
	You can use this in your Dialogic timelines with the [signal] command.
	For example:
	[signal value="add_xp 25"]
	[signal value="add_score 10"]
	"""
	var parts = argument.split(" ")
	if parts.size() < 2:
		print("DEBUG: Invalid dialogic signal format. Expected 'command value'. Got: ", argument)
		return
	
	var command = parts[0]
	var value_str = parts[1]
	
	if not value_str.is_valid_int():
		print("DEBUG: Invalid value for dialogic signal. Expected an integer. Got: ", value_str)
		return
	
	var value = value_str.to_int()
	
	match command:
		"add_xp":
			PlayerStats.add_xp(value)
			print("DEBUG: Added ", value, " XP. Current XP: ", PlayerStats.get_stats().xp)
		"add_score":
			PlayerStats.add_score(value)
			print("DEBUG: Added ", value, " score. Current score: ", PlayerStats.get_stats().score)
		_:
			print("DEBUG: Unknown command for dialogic signal: ", command)
