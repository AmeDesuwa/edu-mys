extends Node

signal evidence_unlocked(evidence_id: String)

const SAVE_PATH = "user://evidence.sav"

# Master evidence library
var evidence_definitions = {
	# Chapter 1: Faculty Room A/C Sabotage Mystery
	"exam_papers_c1": {
		"id": "exam_papers_c1",
		"title": "Damaged Exam Papers",
		"description": "Grade 12-A History examination papers ruined by water damage from the faculty room leak. All papers are unreadable.",
		"image_path": "res://assets/evidence/placeholder_document.png",
		"chapter": 1
	},
	"janitor_testimony_c1": {
		"id": "janitor_testimony_c1",
		"title": "Janitor Fred's Statement",
		"description": "Janitor Fred reported that the A/C unit started leaking yesterday evening. It was discovered this morning by the English teacher.",
		"image_path": "res://assets/evidence/placeholder_document.png",
		"chapter": 1
	},
	"cut_tube_c1": {
		"id": "cut_tube_c1",
		"title": "Cut A/C Tube Photo",
		"description": "Principal's photo shows the A/C drainage tube was deliberately cut, not naturally damaged. This was sabotage, not an accident.",
		"image_path": "res://assets/evidence/placeholder_leak.png",
		"chapter": 1
	},
	"wifi_logs_c1": {
		"id": "wifi_logs_c1",
		"title": "Faculty Wi-Fi Logs",
		"description": "Two devices connected to Faculty_Wifi yesterday evening: 'Galaxy_A52' at 8:00 PM and 'Redmi_Note_10' at 9:00 PM. These belong to Ben and Greg.",
		"image_path": "res://assets/evidence/placeholder_document.png",
		"chapter": 1
	},
	"charm_bracelet_c1": {
		"id": "charm_bracelet_c1",
		"title": "Charm Bracelet",
		"description": "A small, worn charm bracelet with distinctive blue, red, and white beads, and a tiny silver cross. Found under the desk near the AC unit in the faculty room. This belonged to Greg's grandmother and is his most treasured possession.",
		"image_path": "res://Pics/Charm.png",
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
		if evidence_definitions.has(id):
			var evidence_chapter = evidence_definitions[id]["chapter"]
			# Show all evidence collected up to and including the given chapter
			if evidence_chapter <= chapter:
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
