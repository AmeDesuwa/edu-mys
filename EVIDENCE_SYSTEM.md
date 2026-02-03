# Evidence System Documentation

## Overview

The Evidence System allows players to collect clues throughout each chapter's mystery case. Evidence is unlocked at key narrative moments and can be viewed at any time through the Evidence UI panel. Each piece of evidence includes a title, description, and optional image.

## Architecture

### Core Components

1. **EvidenceManager** (`autoload/evidence_manager.gd`) - Autoload singleton
   - Stores all evidence definitions
   - Tracks collected evidence
   - Persists evidence to save file
   - Filters evidence by chapter

2. **EvidenceButtonManager** (`autoload/evidence_button_manager.gd`) - Autoload singleton
   - Controls the persistent Evidence UI button
   - Shows/hides button during gameplay
   - Opens the evidence panel when clicked

3. **EvidencePanel** (`scenes/ui/evidence/evidence_panel.gd`)
   - Displays collected evidence for current chapter
   - Paginated view (3 items per page)
   - Handles Escape key to close panel

4. **DialogicSignalHandler** (`scripts/dialogic_signal_handler.gd`)
   - Routes `unlock_evidence` signals from timelines

### Data Flow

```
Timeline → [signal arg="unlock_evidence evidence_id"] → DialogicSignalHandler
→ EvidenceManager.unlock_evidence() → evidence_unlocked signal
→ Saved to user://evidence.sav
```

## Evidence Definition Structure

Evidence is defined in `EvidenceManager.evidence_definitions` dictionary:

```gdscript
var evidence_definitions = {
	"evidence_id": {
		"id": "evidence_id",
		"title": "Evidence Title",
		"description": "Detailed description of the evidence and its significance.",
		"image_path": "res://assets/evidence/image.png",
		"chapter": 1
	}
}
```

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Unique identifier (must match dictionary key) |
| `title` | String | Short title displayed in evidence panel |
| `description` | String | Full description shown when viewing evidence |
| `image_path` | String | Path to evidence image (use placeholders if no custom image) |
| `chapter` | int | Which chapter this evidence belongs to (1-5) |

## Adding Evidence to a Chapter

### Step 1: Define Evidence in EvidenceManager

Open `autoload/evidence_manager.gd` and add evidence definitions to the `evidence_definitions` dictionary:

```gdscript
var evidence_definitions = {
	// ... existing evidence ...

	# Chapter 2: Student Council Fund Theft Mystery
	"empty_lockbox_c2": {
		"id": "empty_lockbox_c2",
		"title": "Empty Lockbox",
		"description": "The Student Council lockbox found completely empty. Twenty thousand pesos meant for the outreach fund - money to help 12 students who needed supplies - was stolen.",
		"image_path": "res://assets/evidence/placeholder_document.png",
		"chapter": 2
	},
	"threatening_note_c2": {
		"id": "threatening_note_c2",
		"title": "Threatening Note to Ria",
		"description": "Anonymous note left in Ria's locker: 'I know what you did with last year's fund. Resign or I'll expose you.' Written with careful, precise handwriting.",
		"image_path": "res://assets/evidence/placeholder_document.png",
		"chapter": 2
	}
}
```

### Step 2: Add Unlock Signals to Timelines

In your chapter's timeline files, add `[signal arg="unlock_evidence evidence_id"]` at key narrative moments:

#### Example: Chapter 2 Scene 1 (c2s1.dtl)

```
Mark: The lockbox was empty. Not a single peso left.
[signal arg="unlock_evidence empty_lockbox_c2"]
Conrad: That's a lot of money. When did this happen?
```

#### Example: Chapter 2 Scene 3 (c2s3.dtl)

```
Ria: It said... "I know what you did with last year's fund. Resign or I'll expose you."
[signal arg="unlock_evidence threatening_note_c2"]
Mark: Someone was threatening you?
```

### Step 3: Evidence Naming Convention

Follow this pattern for evidence IDs:

```
[description]_c[chapter_number]

Examples:
- exam_papers_c1
- threatening_note_c2
- broken_sculpture_c3
```

This makes it clear which chapter the evidence belongs to.

### Step 4: Test Evidence Collection

1. Play through the chapter
2. Verify evidence unlocks at the correct moments
3. Check the Evidence button appears
4. Open evidence panel and confirm evidence displays correctly
5. Test pagination if you have more than 3 evidence items

## Current Evidence by Chapter

### Chapter 1: Faculty Room A/C Sabotage Mystery

| Evidence ID | Title | Description |
|-------------|-------|-------------|
| `exam_papers_c1` | Damaged Exam Papers | Grade 12-A History exams ruined by water damage |
| `janitor_testimony_c1` | Janitor Fred's Statement | Janitor reported A/C leak discovered this morning |
| `cut_tube_c1` | Cut A/C Tube Photo | Principal's photo shows deliberate sabotage |
| `wifi_logs_c1` | Faculty Wi-Fi Logs | Two devices connected: Galaxy_A52 and Redmi_Note_10 |
| `charm_bracelet_c1` | Charm Bracelet | Distinctive bracelet found under desk, belongs to Greg |

**Unlock Locations:**
- c1s2.dtl - Janitor testimony
- c1s3.dtl - Exam papers, cut tube, wifi logs
- c1s5.dtl - Charm bracelet

### Chapter 2: Student Council Fund Theft Mystery

| Evidence ID | Title | Description |
|-------------|-------|-------------|
| `empty_lockbox_c2` | Empty Lockbox | Twenty thousand pesos stolen from outreach fund |
| `witness_timeline_c2` | Witness Timeline | Timeline of who was present during the theft |
| `threatening_note_c2` | Threatening Note to Ria | Anonymous threat found in Ria's locker |
| `ryan_budget_draft_c2` | Ryan's Budget Proposal Draft | Handwriting matches the threatening note |
| `recovered_money_c2` | Recovered Fund Money | Money found hidden in gym bag |

**Unlock Locations:**
- c2s1.dtl - Empty lockbox
- c2s2.dtl - Witness timeline
- c2s3.dtl - Threatening note
- c2s4.dtl - Ryan's budget draft
- c2s5.dtl - Recovered money

### Chapter 3: Broken Sculpture Mystery

| Evidence ID | Title | Description |
|-------------|-------|-------------|
| `broken_sculpture_note_c3` | Broken Sculpture & Note | Mia's sculpture destroyed, threatening note left at scene |
| `paint_cloth_c3` | Paint-Stained Cloth | Fabric found at crime scene with various paint colors |
| `victor_sketchbook_c3` | Victor's Sketchbook | Angry sketches showing resentment toward Mia's work |
| `art_store_receipt_c3` | Art Store Receipt | Receipt proving Victor lied about being home |
| `inventory_tag_cloth_c3` | Inventory-Tagged Cloth | Cloth with tag 14-C linking to Victor's supplies |

**Unlock Locations:**
- c3s1.dtl - Broken sculpture & note, Paint-stained cloth
- c3s3.dtl - Victor's sketchbook, Art store receipt, Inventory-tagged cloth

### Chapters 4-5

Evidence has not been implemented yet. Follow the pattern from Chapters 1-3 when adding evidence to these chapters.

## Evidence Images

### Placeholder Images

Current placeholder images in `assets/evidence/`:
- `placeholder_document.png` - Generic document/paper evidence
- `placeholder_leak.png` - Water leak/damage evidence

### Adding Custom Images

1. Create image (recommended size: 400x300 pixels)
2. Save to `assets/evidence/` folder
3. Update evidence definition:
   ```gdscript
   "image_path": "res://assets/evidence/your_image.png"
   ```

## Evidence Panel UI

### Display Format

The evidence panel shows:
- **Title**: "Clues in Chapter N"
- **Evidence Items**: Up to 3 per page
  - Image (if available)
  - Title below image
- **Navigation**: Back/Next buttons for pagination
- **Close**: Press Escape or Back button when on page 1

### Input Handling

The evidence panel has special Escape key handling:

```gdscript
func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):
		hide_evidence_panel()
		get_viewport().set_input_as_handled()  # Prevents pause menu
```

This ensures pressing Escape closes the evidence panel instead of opening the pause menu.

## Evidence Persistence

### Save File

Evidence is saved to `user://evidence.sav` in JSON format:

```json
{
	"collected": ["exam_papers_c1", "janitor_testimony_c1", ...]
}
```

### Persistence Functions

```gdscript
# Save collected evidence
func save_evidence():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {"collected": collected_evidence}
	file.store_string(JSON.stringify(data))

# Load saved evidence
func load_evidence():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		collected_evidence = data["collected"]

# Reset all evidence (for testing)
func reset_evidence():
	collected_evidence = []
	save_evidence()
```

### Resetting Evidence

To reset evidence (useful for testing):

In a timeline:
```
[signal arg="reset_evidence"]
```

Or from code:
```gdscript
EvidenceManager.reset_evidence()
```

## Adding Evidence to a New Chapter - Complete Example

Let's add evidence to Chapter 3 (broken sculpture case):

### Step 1: Define Evidence

```gdscript
# In autoload/evidence_manager.gd

# Chapter 3: Broken Sculpture Mystery
"broken_sculpture_c3": {
	"id": "broken_sculpture_c3",
	"title": "Broken Sculpture",
	"description": "Victor's geometric sculpture found shattered on the floor. The pieces show signs of deliberate force, not accidental damage.",
	"image_path": "res://assets/evidence/placeholder_document.png",
	"chapter": 3
},
"security_footage_c3": {
	"id": "security_footage_c3",
	"title": "Security Camera Footage",
	"description": "Hallway footage shows two students near the art room around the time the sculpture was destroyed. Quality is poor but movement patterns are visible.",
	"image_path": "res://assets/evidence/placeholder_document.png",
	"chapter": 3
},
"paint_residue_c3": {
	"id": "paint_residue_c3",
	"title": "Paint Residue",
	"description": "Red acrylic paint found on sculpture fragments. This paint isn't from Victor's piece - someone else's artwork was involved.",
	"image_path": "res://assets/evidence/placeholder_document.png",
	"chapter": 3
}
```

### Step 2: Add Unlock Signals to Timelines

In `content/timelines/Chapter 3/c3s1.dtl`:
```
Conrad: The sculpture is completely destroyed.
[signal arg="unlock_evidence broken_sculpture_c3"]
```

In `content/timelines/Chapter 3/c3s2.dtl`:
```
Security: Here's the footage from last night.
[signal arg="unlock_evidence security_footage_c3"]
```

In `content/timelines/Chapter 3/c3s3.dtl`:
```
Conrad: What's this red paint doing here?
[signal arg="unlock_evidence paint_residue_c3"]
```

### Step 3: Initialize Chapter Variables

In `content/timelines/Chapter 3/c3s0.dtl`:
```
[signal arg="show_title_card 3"]
[background arg="res://Bg/art_room.png" fade="2.0"]
set {current_chapter} = 3
set {selected_subject} = "English"
set {chapter3_score} = 0
```

### Step 4: Test

1. Play Chapter 3
2. Verify evidence unlocks appear at correct moments
3. Open Evidence panel and check all items display
4. Confirm chapter filter shows only Chapter 3 evidence

## Best Practices

### Evidence Design

1. **Make evidence meaningful** - Each piece should advance the investigation
2. **Unlock at dramatic moments** - When the player discovers something important
3. **Keep descriptions concise** - 2-3 sentences maximum
4. **Provide context** - Explain why this evidence matters
5. **Use clear titles** - Player should immediately recognize what it is

### Timing Evidence Unlocks

Good timing examples:
- ✅ After discovering a key clue
- ✅ Following witness testimony
- ✅ When examining physical evidence
- ✅ After making an important deduction

Poor timing examples:
- ❌ During unrelated dialogue
- ❌ Before the evidence is actually discovered
- ❌ Multiple unlocks in rapid succession
- ❌ During minigames or transitions

### Evidence Quantity

- **Minimum**: 3 pieces per chapter (one page)
- **Recommended**: 4-6 pieces (provides investigation depth)
- **Maximum**: 9 pieces (three pages, avoid overwhelming player)

Chapter 1 has 5 pieces, Chapter 2 has 5 pieces - this is a good benchmark.

## Troubleshooting

### Issue: Evidence Not Unlocking

**Symptoms:** Signal fires but evidence doesn't appear in panel

**Solutions:**
1. Check evidence ID matches exactly in both definition and signal
2. Verify evidence definition has correct chapter number
3. Check `current_chapter` variable is set correctly
4. Look for typos in evidence_id (case-sensitive)

### Issue: Evidence Panel Shows Wrong Chapter

**Symptoms:** Evidence from other chapters appears

**Solutions:**
1. Ensure `current_chapter` variable is set at chapter start
2. Check evidence definitions have correct `"chapter"` field
3. Verify `get_evidence_by_chapter()` is filtering correctly

### Issue: Evidence Panel Won't Close

**Symptoms:** Escape key doesn't work

**Solutions:**
1. Check `_input()` function in evidence_panel.gd is present
2. Verify input isn't being consumed elsewhere
3. Test with mouse click on Back button as alternative

### Issue: Evidence Not Persisting

**Symptoms:** Evidence resets when reloading game

**Solutions:**
1. Check save file exists at `user://evidence.sav`
2. Verify `save_evidence()` is called after unlock
3. Test `load_evidence()` is called in `_ready()`
4. Check file permissions for save directory

## API Reference

### EvidenceManager

```gdscript
# Unlock a piece of evidence
func unlock_evidence(evidence_id: String)

# Check if evidence is unlocked
func is_unlocked(evidence_id: String) -> bool

# Get all evidence for a chapter
func get_evidence_by_chapter(chapter: int) -> Array

# Save evidence to disk
func save_evidence()

# Load evidence from disk
func load_evidence()

# Reset all evidence
func reset_evidence()
```

### Signals

```gdscript
# Emitted when new evidence is unlocked
signal evidence_unlocked(evidence_id: String)
```

## Related Documentation

- [CLAUDE.md](CLAUDE.md) - Overall architecture
- [CURRICULUM_SYSTEM.md](CURRICULUM_SYSTEM.md) - Curriculum questions
- [README.md](README.md) - Project overview

---

**Last Updated**: 2026-02-02
**Version**: 1.0
