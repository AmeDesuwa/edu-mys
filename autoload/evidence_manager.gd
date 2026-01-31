extends Node

signal evidence_unlocked(evidence_id: String)

const SAVE_PATH = "user://evidence.sav"

# Master evidence library
var evidence_definitions = {
	# Chapter 1: Faculty Room Leak Mystery
	"exam_papers_c1": {
		"id": "exam_papers_c1",
		"title": "Damaged Exam Papers",
		"description": "Grade 12-A History examination papers ruined by water damage. Found in faculty room filing cabinet.",
		"image_path": "res://assets/evidence/placeholder_document.png",
		"chapter": 1
	},
	"water_source_c1": {
		"id": "water_source_c1",
		"title": "Water Leak Source",
		"description": "Leak originated from ceiling area near the air conditioning unit. Recent maintenance records show no issues.",
		"image_path": "res://assets/evidence/placeholder_leak.png",
		"chapter": 1
	},
	"bracelet_c1": {
		"id": "bracelet_c1",
		"title": "Silver Bracelet",
		"description": "Silver bracelet found on the floor near the leak site. Has initials 'M.S.' engraved on the inside.",
		"image_path": "res://assets/evidence/placeholder_jewelry.png",
		"chapter": 1
	},
	"maintenance_log_c1": {
		"id": "maintenance_log_c1",
		"title": "Maintenance Log",
		"description": "Building maintenance log showing recent A/C servicing. Last entry dated 3 days before the incident.",
		"image_path": "res://assets/evidence/placeholder_document.png",
		"chapter": 1
	},
	"witness_statement_c1": {
		"id": "witness_statement_c1",
		"title": "Witness Statement",
		"description": "Statement from a student who was near the faculty room the previous evening. Heard unusual sounds.",
		"image_path": "res://assets/evidence/placeholder_document.png",
		"chapter": 1
	}
}

# Player's collected evidence
var collected_evidence: Array = []

func _ready():
	load_evidence()

func unlock_evidence(evidence_id: String):
	if not evidence_definitions.has(evidence_id):
		push_error("Unknown evidence ID: ", evidence_id)
		return

	if not collected_evidence.has(evidence_id):
		collected_evidence.append(evidence_id)
		save_evidence()
		evidence_unlocked.emit(evidence_id)
		print("Evidence unlocked: ", evidence_definitions[evidence_id]["title"])

func is_unlocked(evidence_id: String) -> bool:
	return collected_evidence.has(evidence_id)

func get_evidence_by_chapter(chapter: int) -> Array:
	var chapter_evidence = []
	for id in collected_evidence:
		if evidence_definitions.has(id) and evidence_definitions[id]["chapter"] == chapter:
			chapter_evidence.append(evidence_definitions[id])

	# Sort by collection order (chronological)
	return chapter_evidence

func save_evidence():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var data = {"collected": collected_evidence}
		file.store_string(JSON.stringify(data))

func load_evidence():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var data = JSON.parse_string(json_string)
			if data and data.has("collected"):
				collected_evidence = data["collected"]

func reset_evidence():
	collected_evidence = []
	save_evidence()
