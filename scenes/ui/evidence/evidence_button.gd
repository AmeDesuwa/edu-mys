extends CanvasLayer

@onready var evidence_button = $EvidenceButton
var evidence_screen = preload("res://scenes/ui/evidence/evidence_screen.tscn")
var evidence_screen_instance = null

func _ready():
	evidence_button.pressed.connect(_on_evidence_pressed)

func _on_evidence_pressed():
	# Don't open multiple instances
	if evidence_screen_instance != null and is_instance_valid(evidence_screen_instance):
		return

	# Instantiate evidence screen
	evidence_screen_instance = evidence_screen.instantiate()
	get_tree().root.add_child(evidence_screen_instance)

	# Show with current chapter filter
	var current_chapter = Dialogic.VAR.current_chapter if Dialogic.VAR.has("current_chapter") else 1
	evidence_screen_instance.show_evidence(current_chapter)
