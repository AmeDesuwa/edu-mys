extends CanvasLayer

@onready var button = $Button
@onready var evidence_panel = $EvidencePanel

func _ready():
	# Initially hide the evidence panel
	if evidence_panel:
		evidence_panel.visible = false

func _on_button_pressed():
	if evidence_panel:
		# Toggle evidence panel visibility
		if evidence_panel.visible:
			evidence_panel.hide_evidence_panel()
		else:
			evidence_panel.show_evidence_panel()
