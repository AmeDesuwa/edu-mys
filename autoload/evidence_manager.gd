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
		"title": "Charm Bracelet",
		"description": "A worn charm bracelet with distinctive blue, red, and white beads, and a tiny silver cross. Found under the desk in the faculty room.",
		"image_path": "res://Bg/Charm.png",
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
	},
	"wifi_logs_c1": {
		"id": "wifi_logs_c1",
		"title": "WiFi Connection Logs",
		"description": "Faculty WiFi logs showing two devices connected yesterday evening: Galaxy A52 at 8:00 PM and Redmi Note 10 at 9:00 PM.",
		"image_path": "res://Pics/Wifi_Logs.png",
		"chapter": 1
	},
	"spider_envelope_c1": {
		"id": "spider_envelope_c1",
		"title": "Mysterious Envelope",
		"description": "An envelope given to Greg containing a faculty room key. No name written on it, but stamped with a pixelated spider symbol on the inside flap.",
		"image_path": "res://Pics/clue3.png",
		"chapter": 1
	},
	# Chapter 2: Student Council Mystery
	"lockbox_c2": {
		"id": "lockbox_c2",
		"title": "Empty Lockbox",
		"description": "The Student Council lockbox sits empty on the desk. Whatever was inside has been taken, leaving only questions behind.",
		"image_path": "res://Pics/lockbox.jpg",
		"chapter": 2
	},
	"threat_note_c2": {
		"id": "threat_note_c2",
		"title": "Threatening Note",
		"description": "A threatening note found in Ria's locker: \"I know what you did with last year's fund. Resign or I'll expose you.\" Someone was blackmailing her.",
		"image_path": "res://Pics/threat_note.jpg",
		"chapter": 2
	}
}

# Player's collected evidence
var collected_evidence: Array = []

func _ready():
	# Evidence is now loaded per-save-slot by SaveManager
	# Delete old global evidence file if it exists (migration)
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("Migrated: Deleted old global evidence file, evidence is now saved per-slot")

func unlock_evidence(evidence_id: String):
	if not evidence_definitions.has(evidence_id):
		push_error("Unknown evidence ID: ", evidence_id)
		return

	if not collected_evidence.has(evidence_id):
		collected_evidence.append(evidence_id)
		# Don't save to global file - evidence is now saved per-slot by SaveManager
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

## DEPRECATED: Evidence is now saved per-slot by SaveManager
## This function is kept for backwards compatibility but should not be used
func save_evidence():
	push_warning("save_evidence() is deprecated - evidence is now saved per-slot by SaveManager")
	# Don't save to global file anymore

## DEPRECATED: Evidence is now loaded per-slot by SaveManager
## This function is kept for backwards compatibility but should not be used
func load_evidence():
	push_warning("load_evidence() is deprecated - evidence is now loaded per-slot by SaveManager")
	# Don't load from global file anymore

func reset_evidence():
	collected_evidence = []
	# Evidence is now managed per-slot by SaveManager, no need to save globally
