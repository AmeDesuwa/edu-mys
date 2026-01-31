# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

EduMys is an educational mystery visual novel built in Godot 4.5. The player solves detective cases through dialogue choices and minigames while leveling up to unlock abilities.

## Running the Game

Open the project in Godot 4.5 and press F5, or run from command line:
```bash
# Windows (adjust path to your Godot installation)
"C:/Program Files/Godot/Godot.exe" --path .
```

## Architecture

### Autoload Singletons (project.godot)

The game uses several autoloaded singletons that are always available:

- **Dialogic** - Third-party narrative system (handles all dialogue, characters, timelines)
- **PlayerStats** (`src/core/PlayerStats.gd`) - XP, score, level persistence to `user://player_stats.sav`
- **LevelUpManager** (`autoload/level_up_manager.gd`) - Shows level-up UI with unlocked abilities
- **MinigameManager** (`autoload/minigame_manager.gd`) - Spawns and configures minigames
- **DialogicSignalHandler** (`scripts/dialogic_signal_handler.gd`) - Routes Dialogic signals to game systems
- **EvidenceManager** (`autoload/evidence_manager.gd`) - Manages evidence collection and unlocking
- **EvidenceButtonManager** (`autoload/evidence_button_manager.gd`) - Controls persistent Evidence UI button

### Dialogic Integration

Dialogic 2.x is the core narrative engine. Key patterns:

**Timeline files** (`.dtl`) use this syntax:
```
[background arg="res://Bg/classroom.png" fade="1.0"]
join Conrad (half) left
Conrad: Dialogue text here.
[signal arg="start_minigame puzzle_id"]
set {variable_name} = value
set {variable_name} += 10
label my_label
jump my_label
jump other_timeline/
```

**Dialogic variables** are accessed via `Dialogic.VAR.variable_name`. Key variables:
- `conrad_level` - Player's detective level (1-10)
- `minigames_completed` - Count of completed minigames in chapter
- `chapter1_score`, `chapter2_score`, etc. - Per-chapter scoring

**Signal handling**: Timeline `[signal]` events trigger `DialogicSignalHandler._on_dialogic_signal()`. To pause Dialogic during async operations (minigames, level-ups):
```gdscript
Dialogic.paused = true
await some_async_operation()
Dialogic.paused = false
```

### Minigame System

Minigames are triggered from timelines via `[signal arg="start_minigame puzzle_id"]`.

`MinigameManager` handles various minigame types:
- **Fill-in-the-blank** (`minigames/Drag/`) - Drag-and-drop word completion
- **Runner** - Answer questions while running
- **Pacman** - Collect correct answers while avoiding enemies
- **Platformer** - Collect items while platforming
- **Maze** - Navigate maze while answering questions
- **Pronunciation** - Speech recognition minigame
- **Math** - Math problem solving
- **Dialogue Choice** (IN DEVELOPMENT) - Select and speak correct dialogue options with voice recognition

#### Dialogue Choice Minigame (IN DEVELOPMENT - Vosk Integration)

Located at `minigames/DialogueChoice/scenes/Main.tscn`.

**Current Status:** Voice recognition is functional but still being optimized for accuracy and performance.

**Features:**
- Multiple choice dialogue selection (4 options)
- Real-time voice recognition via Vosk speech-to-text engine
- 1:30 timer countdown
- Wrong answer feedback with retry mechanism (wrong choices are disabled after selection)
- Correct answer triggers sentence-based pronunciation verification

**Voice Recognition System:**
- Uses `GodotVoskRecognizer` with English model (`vosk-model-small-en-us-0.15`)
- Microphone audio captured via `AudioStreamMicrophone` on muted "Record" bus (prevents echo)
- Real-time partial transcription display while speaking
- Automatic silence detection (stops after 1.5s of silence)
- Sentence-based matching (60% word match threshold)
- Levenshtein distance algorithm for word similarity (70% per-word threshold)

**Known Issues (Under Development):**
- Vosk accuracy varies with microphone quality and background noise
- Silence detection may be too sensitive/insensitive depending on environment
- Long sentences may have lower match rates
- Performance optimization needed for real-time processing

**Usage in Timelines:**
```
[signal arg="start_minigame dialogue_choice_janitor"]
```

**Voice Recognition Flow:**
1. Player selects correct dialogue choice (Choice 2 for janitor scenario)
2. Full sentence displays on screen
3. Player speaks naturally: "Good afternoon, sir. I was hoping you could help me..."
4. Vosk processes speech in real-time, showing partial transcription
5. After 1.5s silence, final result is matched against target sentence
6. Success (≥60% match) completes minigame, failure allows retry

**Technical Details:**
- Script: `minigames/DialogueChoice/scenes/Main.gd`
- Audio capture: 16kHz mono PCM, 100ms buffer
- Processing: 4096-byte chunks sent to Vosk
- Registered in `MinigameManager._start_dialogue_choice()`

To add a new minigame, register it in `MinigameManager.start_minigame()` and create the corresponding handler function.

### Level-Up System

10 levels with abilities defined in `LevelUpManager.ability_data`. Level-ups are triggered via:
- `[signal arg="show_level_up"]` - Shows level-up for current `conrad_level`
- `[signal arg="check_level_up"]` - Checks if conditions met and shows level-up

The flashy level-up scene is at `scenes/ui/level_up_scene_flashy.tscn`.

### Evidence System

Evidence is managed through two autoload singletons:

**EvidenceManager** tracks collected evidence:
- Evidence definitions in `evidence_definitions` dictionary
- Per-chapter evidence filtering via `get_evidence_by_chapter()`
- Unlock evidence via `[signal arg="unlock_evidence evidence_id"]` in timelines
- Evidence persists to `user://evidence.sav`

**EvidenceButtonManager** displays persistent UI:
- Evidence button appears in top-right corner during gameplay
- Shows/hides automatically when timelines start/end
- Opens evidence panel showing collected clues for current chapter
- History feature is disabled - only Evidence button shows

Example evidence unlock in timeline:
```
Conrad: I should remember this...
[signal arg="unlock_evidence exam_papers_c1"]
```

### Content Organization

- `content/characters/` - Dialogic character files (`.dch`)
- `content/timelines/Chapter N/` - Timeline files named `cNsM.dtl` (Chapter N, Scene M)
- Timeline naming: `c1s1` = Chapter 1 Scene 1, `c1s2b` = Chapter 1 Scene 2 branch
- `assets/evidence/` - Evidence placeholder images (see README.md in folder)

### Multiple Choice with Retry

For choices where wrong answers should loop back:
```
label choice_label
Character: Question text?
- Wrong choice
    Character: Feedback explaining why wrong.
    jump choice_label
- Correct choice
    Character: Correct response.
```

## Key Dialogic 2.x Notes

- Use `Dialogic.signal_event.connect()` not `Dialogic.dialogic_signal` (that's v1.x)
- Variables: `set {var} = value`, `set {var} += 10`, `set {var} -= 5`
- Jumps within timeline: `jump label_name`
- Jumps to other timeline: `jump timeline_name/`
