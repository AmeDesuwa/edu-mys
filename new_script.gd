extends Node

var vosk: GodotVoskRecognizer

func _ready():
	vosk = GodotVoskRecognizer.new()
	
	if vosk:
		print("GodotVoskRecognizer loaded successfully!")
		
		# Convert res:// path to absolute filesystem path
		var model_path = "res://addons/vosk/models/vosk-model-small-en-us-0.15"
		var absolute_path = ProjectSettings.globalize_path(model_path)
		
		print("Trying to load model from: ", absolute_path)
		
		if vosk.initialize(absolute_path, 16000.0):
			print("Vosk initialized!")
		else:
			print("Failed to initialize Vosk")
	else:
		print("Failed to create GodotVoskRecognizer")
