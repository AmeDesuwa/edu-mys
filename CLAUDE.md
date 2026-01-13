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

`MinigameManager.puzzle_configs` contains puzzle definitions with sentence_parts, answers, and choices. The fill-in-the-blank minigame (`minigames/Drag/`) uses drag-and-drop mechanics.

To add a new puzzle, add an entry to `puzzle_configs` in `minigame_manager.gd` and reference it in a timeline.

### Level-Up System

10 levels with abilities defined in `LevelUpManager.ability_data`. Level-ups are triggered via:
- `[signal arg="show_level_up"]` - Shows level-up for current `conrad_level`
- `[signal arg="check_level_up"]` - Checks if conditions met and shows level-up

The flashy level-up scene is at `scenes/ui/level_up_scene_flashy.tscn`.

### Content Organization

- `content/characters/` - Dialogic character files (`.dch`)
- `content/timelines/Chapter N/` - Timeline files named `cNsM.dtl` (Chapter N, Scene M)
- Timeline naming: `c1s1` = Chapter 1 Scene 1, `c1s2b` = Chapter 1 Scene 2 branch

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
