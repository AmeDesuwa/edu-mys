extends Node

# Evidence Button Manager - Manages persistent Evidence button UI

const EVIDENCE_BUTTON_SCENE := preload("res://scenes/ui/evidence/evidence_button.tscn")

var evidence_button_instance: CanvasLayer = null
var button_enabled := false

func _ready() -> void:
	# Listen for when Dialogic starts/ends to show/hide the button
	if Dialogic.timeline_started.is_connected(_on_timeline_started) == false:
		Dialogic.timeline_started.connect(_on_timeline_started)
	if Dialogic.timeline_ended.is_connected(_on_timeline_ended) == false:
		Dialogic.timeline_ended.connect(_on_timeline_ended)
	
	# Note: Title card visibility is now handled directly in TitleCardManager
	# to ensure proper timing and layer management

func _on_timeline_started() -> void:
	button_enabled = true
	show_evidence_button()

func _on_timeline_ended() -> void:
	button_enabled = false
	hide_evidence_button()


func show_evidence_button() -> void:
	if evidence_button_instance != null and is_instance_valid(evidence_button_instance):
		evidence_button_instance.visible = true
		return

	# Create evidence button instance
	evidence_button_instance = EVIDENCE_BUTTON_SCENE.instantiate()
	evidence_button_instance.layer = 99  # Below pause menu but above game content
	get_tree().root.add_child(evidence_button_instance)

func hide_evidence_button() -> void:
	if evidence_button_instance and is_instance_valid(evidence_button_instance):
		evidence_button_instance.visible = false

func cleanup() -> void:
	if evidence_button_instance and is_instance_valid(evidence_button_instance):
		evidence_button_instance.queue_free()
		evidence_button_instance = null
