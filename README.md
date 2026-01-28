# EduMys - Educational Mystery Visual Novel

A detective mystery educational game built in Godot 4.5, featuring interactive dialogue, minigames, and voice recognition capabilities.

## Project Structure

```
edu-mys/
├── addons/              # Third-party addons
│   ├── dialogic/       # Narrative system
│   └── vosk/           # Speech recognition
│
├── assets/             # Game assets
│   ├── audio/          # Audio files and test samples
│   ├── backgrounds/    # Background images
│   ├── pictures/       # UI pictures and evidence images
│   └── sprites/        # Character sprites
│
├── autoload/           # Global autoload scripts
│   └── level_up_manager.gd
│
├── content/            # Game narrative content
│   ├── characters/     # Dialogic character definitions (.dch)
│   └── timelines/      # Dialogic dialogue timelines (.dtl)
│       ├── Chapter 1/
│       └── Chapter 2/
│
├── minigames/          # Interactive minigames
│   ├── Drag/          # Fill-in-the-blank drag puzzle
│   └── Pacman/        # Quiz game with enemies
│
├── scenes/             # Game scenes
│   ├── effects/       # Visual effects (DialogicEffectsManager)
│   └── ui/            # UI scenes (level_up_scene, etc.)
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
- UI in `scenes/ui/level_up_scene.*`

### Vosk Speech Recognition (Experimental)
- Located in `src/vosk/`
- `VoskPronunciationGame.gd` - Ready-to-use pronunciation minigame class
- `VoskAudioFileTester.gd` - Audio testing utility
- Model: `addons/vosk/models/vosk-model-small-en-us-0.15/`

### Minigames
- **Pacman Quiz**: Navigate to correct answers while avoiding enemies
- **Fill-in-the-Blank**: Drag-and-drop word puzzle

### Player Progression
- XP and leveling system
- Stored in `src/core/PlayerStats.gd`
- Persists to `user://player_stats.sav`

## Development Status

**Completed:**
- Chapter 1 narrative (5 scenes, nearly polished)
- Level-up system v1
- Two minigame prototypes
- Vosk API integration

**In Progress:**
- Chapter 2 story content (early stage)
- Vosk game node integration

## Technical Details

- **Engine:** Godot 4.5
- **Resolution:** 1920x1080
- **Renderer:** GL Compatibility
- **Main Scene:** node_2d.tscn
