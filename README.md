# EduMys - Educational Mystery Visual Novel

A detective mystery educational game built in Godot 4.5, featuring interactive dialogue, minigames, voice recognition, and evidence collection capabilities.

## Project Structure

```
edu-mys/
├── addons/              # Third-party addons
│   ├── dialogic/       # Narrative system (Dialogic 2.x)
│   └── vosk/           # Speech recognition
│
├── assets/             # Game assets
│   ├── audio/          # Audio files and test samples
│   ├── backgrounds/    # Background images
│   ├── evidence/       # Evidence images (placeholders)
│   ├── pictures/       # UI pictures and evidence images
│   └── sprites/        # Character sprites
│
├── autoload/           # Global autoload scripts (singletons)
│   ├── curriculum_questions.gd    # Curriculum question database
│   ├── evidence_button_manager.gd # Evidence UI button control
│   ├── evidence_manager.gd        # Evidence collection system
│   ├── level_up_manager.gd        # Level-up system
│   ├── minigame_manager.gd        # Minigame spawning & configuration
│   └── title_card_manager.gd      # Chapter title cards
│
├── content/            # Game narrative content
│   ├── characters/     # Dialogic character definitions (.dch)
│   └── timelines/      # Dialogic dialogue timelines (.dtl)
│       ├── Chapter 1/  # A/C sabotage mystery (5 scenes, complete with evidence)
│       ├── Chapter 2/  # Fund theft mystery (7 scenes, complete with evidence)
│       ├── Chapter 3/  # Broken sculpture mystery (7 scenes, in progress)
│       ├── Chapter 4/  # Hidden journal mystery (7 scenes, in progress)
│       └── Chapter 5/  # Final revelation (6 scenes, in progress)
│
├── minigames/          # Interactive minigames
│   ├── DialogueChoice/ # Voice recognition dialogue minigame (Vosk)
│   ├── Drag/          # Fill-in-the-blank drag puzzle
│   ├── Math/          # Math problem solving
│   ├── Maze/          # Navigate maze to find answers
│   ├── Pacman/        # Quiz game with enemies
│   ├── Platformer/    # Platform-based quiz game
│   ├── Pronunciation/ # Speech recognition minigame
│   └── Runner/        # Running quiz game
│
├── scenes/             # Game scenes
│   ├── effects/       # Visual effects (DialogicEffectsManager)
│   └── ui/            # UI scenes
│       ├── evidence/  # Evidence collection UI
│       └── level_up_scene_flashy.tscn
│
├── scripts/            # Game scripts
│   └── dialogic_signal_handler.gd
│
└── src/                # Core game code
    ├── core/          # Core systems (PlayerStats)
    ├── vosk/          # Vosk integration (VoskPronunciationGame, VoskAudioFileTester)
    └── ui/            # UI components (future)
```

## Key Systems

### Level-Up System
- 10 levels with unlockable detective abilities
- Managed by `autoload/level_up_manager.gd`
- UI in `scenes/ui/level_up_scene_flashy.tscn`
- Abilities defined in `LevelUpManager.ability_data`

### Minigame System

Minigames are triggered from Dialogic timelines and use the curriculum question system for educational content.

**Available Minigames:**
- **Runner**: Answer questions while running
- **Pacman**: Collect correct answers while avoiding enemies
- **Platformer**: Platform-based quiz game
- **Maze**: Navigate maze to find correct answers (see [MAZE_MINIGAME_DOCUMENTATION.md](MAZE_MINIGAME_DOCUMENTATION.md))
- **Fill-in-the-Blank**: Drag-and-drop word completion
- **Math**: Math problem solving
- **Pronunciation**: Speech recognition minigame
- **Dialogue Choice**: Voice recognition dialogue selection (experimental)

**Curriculum Questions:**
- Questions organized by subject, quarter, and minigame type
- Supports English, General Mathematics, Biology, Chemistry, Earth Science
- See [CURRICULUM_SYSTEM.md](CURRICULUM_SYSTEM.md) for details

### Evidence System

Players collect clues throughout each chapter's mystery case.

**Features:**
- Evidence unlocked at key narrative moments via `[signal arg="unlock_evidence evidence_id"]`
- Persistent evidence button during gameplay
- Chapter-filtered evidence viewing
- Saved to `user://evidence.sav`
- Escape key closes evidence panel without opening pause menu

**Current Implementation:**
- Chapter 1: 5 evidence items (complete)
- Chapter 2: 5 evidence items (complete)
- Chapters 3-5: Not yet implemented

See [EVIDENCE_SYSTEM.md](EVIDENCE_SYSTEM.md) for implementation details.

### Vosk Speech Recognition (Experimental)
- Located in `src/vosk/`
- `VoskPronunciationGame.gd` - Ready-to-use pronunciation minigame class
- `VoskAudioFileTester.gd` - Audio testing utility
- Model: `addons/vosk/models/vosk-model-small-en-us-0.15/`
- Used in Dialogue Choice and Pronunciation minigames

### Player Progression
- XP and leveling system
- Stored in `src/core/PlayerStats.gd`
- Persists to `user://player_stats.sav`

## Development Status

**Completed:**
- Chapter 1 narrative (5 scenes) + evidence system
- Chapter 2 narrative (7 scenes) + evidence system
- Level-up system with 10 levels and abilities
- 8 minigame types with curriculum integration
- Evidence collection and persistence
- Vosk speech recognition integration
- Curriculum question system (5 subjects)

**In Progress:**
- Chapters 3-5 content
- Dialogue Choice minigame optimization
- Additional curriculum questions

**Planned:**
- Evidence images (currently using placeholders)
- Additional subjects for curriculum
- More minigame variations

## Technical Details

- **Engine:** Godot 4.5
- **Resolution:** 1920x1080
- **Renderer:** GL Compatibility
- **Dialogue System:** Dialogic 2.x
- **Speech Recognition:** Vosk (vosk-model-small-en-us-0.15)

## Documentation

- **[CLAUDE.md](CLAUDE.md)** - Comprehensive guide for AI assistants (architecture, patterns, systems)
- **[CURRICULUM_SYSTEM.md](CURRICULUM_SYSTEM.md)** - Curriculum question system and adding new content
- **[EVIDENCE_SYSTEM.md](EVIDENCE_SYSTEM.md)** - Evidence collection system implementation
- **[MAZE_MINIGAME_DOCUMENTATION.md](MAZE_MINIGAME_DOCUMENTATION.md)** - Detailed maze minigame guide
- **Chapter Outlines** - Chapter 3-5 story outlines in respective timeline folders

## Quick Start for Development

1. **Clone and open in Godot 4.5**
2. **Read [CLAUDE.md](CLAUDE.md)** for architecture overview
3. **Test a chapter**: Open `content/timelines/Chapter 1/c1s1.dtl` in Dialogic and press "Play Timeline"
4. **Add evidence**: See [EVIDENCE_SYSTEM.md](EVIDENCE_SYSTEM.md)
5. **Add curriculum questions**: See [CURRICULUM_SYSTEM.md](CURRICULUM_SYSTEM.md)
6. **Create new minigame**: Check `autoload/minigame_manager.gd` for registration pattern

## Running the Game

Open the project in Godot 4.5 and press F5, or run from command line:
```bash
# Windows (adjust path to your Godot installation)
"C:/Program Files/Godot/Godot.exe" --path .
```

## Recent Updates (2026-02-02)

- Added evidence system to Chapter 2 (5 items)
- Fixed curriculum minigame freeze on error
- Added Escape key handling to evidence panel
- Set "English" as default subject for all chapters
- Created comprehensive documentation (CURRICULUM_SYSTEM.md, EVIDENCE_SYSTEM.md)
- Standardized chapter initialization pattern
- Updated CLAUDE.md with curriculum system and recent fixes
