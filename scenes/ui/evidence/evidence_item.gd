extends PanelContainer

@onready var icon = $MarginContainer/VBoxContainer/Icon
@onready var title_label = $MarginContainer/VBoxContainer/TitleLabel
@onready var description_label = $MarginContainer/VBoxContainer/DescriptionLabel

func load_evidence(evidence_data: Dictionary):
	title_label.text = evidence_data.get("title", "Unknown")
	description_label.text = evidence_data.get("description", "No description.")

	# Load image (placeholder or actual)
	var image_path = evidence_data.get("image_path", "res://assets/evidence/placeholder_clue.png")
	if ResourceLoader.exists(image_path):
		icon.texture = load(image_path)
	else:
		push_warning("Evidence image not found: ", image_path)
		# Generate simple placeholder
		_generate_placeholder()

func _generate_placeholder():
	var img = Image.create(128, 128, false, Image.FORMAT_RGB8)
	img.fill(Color(0.3, 0.5, 0.7))  # Blue-gray
	var texture = ImageTexture.create_from_image(img)
	icon.texture = texture
