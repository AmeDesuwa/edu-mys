extends CanvasLayer

@onready var title_label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/Header/TitleLabel
@onready var close_button = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/Header/CloseButton
@onready var evidence_grid = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/ScrollContainer/EvidenceGrid
@onready var empty_label = $CenterContainer/MainPanel/MarginContainer/VBoxContainer/EmptyLabel
@onready var main_panel = $CenterContainer/MainPanel

var evidence_item_scene = preload("res://scenes/ui/evidence/evidence_item.tscn")

func _ready():
	close_button.pressed.connect(_on_close_pressed)
	main_panel.modulate.a = 0  # Start invisible for fade-in

func show_evidence(chapter: int):
	# Update title
	title_label.text = "Evidence - Chapter " + str(chapter)

	# Clear existing evidence cards
	for child in evidence_grid.get_children():
		child.queue_free()

	# Get chapter-specific evidence
	var chapter_evidence = EvidenceManager.get_evidence_by_chapter(chapter)

	# Show empty state or populate grid
	if chapter_evidence.size() == 0:
		empty_label.visible = true
		evidence_grid.visible = false
	else:
		empty_label.visible = false
		evidence_grid.visible = true

		# Instantiate evidence cards
		for evidence_data in chapter_evidence:
			var item = evidence_item_scene.instantiate()
			evidence_grid.add_child(item)
			item.load_evidence(evidence_data)

	# Pause Dialogic
	Dialogic.paused = true

	# Fade in
	var tween = create_tween()
	tween.tween_property(main_panel, "modulate:a", 1.0, 0.3)

func _on_close_pressed():
	# Fade out
	var tween = create_tween()
	tween.tween_property(main_panel, "modulate:a", 0.0, 0.2)
	await tween.finished

	# Resume Dialogic
	Dialogic.paused = false

	# Remove self
	queue_free()
