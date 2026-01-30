# Maze Minigame Documentation

## Overview

The Maze minigame is a grid-based puzzle game where players navigate through a maze to collect the correct answer to a question while avoiding wrong answers. The game uses letter-labeled collectibles (A-H) displayed on a maze map, with the full question and answer options shown in a side panel.

## File Locations

### Core Files
- **Maze Scene**: `minigames/Maze/scenes/Main.tscn`
- **Main Script**: `minigames/Maze/scripts/Main.gd`
- **Map Configuration**: `minigames/Maze/scripts/PresetMaps.gd`
- **Player**: `minigames/Maze/scenes/Player.tscn` & `minigames/Maze/scripts/Player.gd`
- **Collectible**: `minigames/Maze/scenes/Collectible.tscn` & `minigames/Maze/scripts/Collectible.gd`

### Integration Files
- **Minigame Manager**: `autoload/minigame_manager.gd` (contains all 20 English communication questions)
- **Signal Handler**: `scripts/dialogic_signal_handler.gd` (triggers minigames from Dialogic timelines)

## Current Configuration

### Maze Size
- **Dimensions**: 25 cells wide × 15 cells tall
- **Cell Size**: 32 pixels per cell
- **Total Size**: 800px × 480px

### Game Mechanics
- **Health**: 3 hearts
- **Scoring**: +100 points per correct answer
- **Penalty**: -1 health per wrong answer collected
- **Win Condition**: Collect all correct answers (currently 1)
- **Lose Condition**: Health reaches 0

## Map Design System

### Map Legend
The maze uses a simple character-based system in `PresetMaps.gd`:

- `#` = Wall (impassable)
- `.` = Floor (walkable path)
- `S` = Start position (player spawns here)
- `1` = Correct answer spot (where the correct answer letter appears)
- `W` = Wrong answer spots (where incorrect answer letters appear)

### Current Map Layout
```
#########################
#S....#.................#
#.###.#.###############.#
#.#W#...#W............#.#
#.#.#####.##.########.#.#
#W#.............#...#.#.#
#.###.#####.#######.#.#.#
#W........#.#W....#...#.#
#########.#.#.###.##.##.#
#.........#W#...#.....#.#
#.#####.#.#####.#####.#.#
#W#...#.#.....#.#W..#...#
#.#.#.#.#####.#.#.#.#####
#...#...#W.............1#
#########################
```

### How to Customize the Map

Edit `minigames/Maze/scripts/PresetMaps.gd`:

```gdscript
const MAP_1 = [
    "#########################",
    "#S....#.................#",  // S = Player starts here
    "#.###.#.###############.#",
    "#.#W#...#W............#.#",  // W = Wrong answer positions
    // ... more rows ...
    "#...#...#W.............1#",  // 1 = Correct answer position
    "#########################",
]
```

**Tips for Map Design:**
- Keep paths wide enough (2-3 cells) for comfortable navigation
- Place `W` markers away from the critical path to `1`
- Test that the correct answer is reachable from start
- Use more `W` markers than you have wrong answers (7 wrong answers max)

## Question System

### Question Format

Questions are stored in `autoload/minigame_manager.gd` under the `maze_configs` dictionary. Each question follows this structure:

```gdscript
"english_communication_q1": {
    "question": {
        "text": "Who is the person who creates the message in the communication process?",
        "options": [
            {"letter": "A", "text": "Sender", "correct": true},
            {"letter": "B", "text": "Receiver", "correct": false},
            {"letter": "C", "text": "Listener", "correct": false},
            {"letter": "D", "text": "Decoder", "correct": false},
            {"letter": "E", "text": "Creates", "correct": false},
            {"letter": "F", "text": "Receives", "correct": false},
            {"letter": "G", "text": "Sends", "correct": false},
            {"letter": "H", "text": "Interprets", "correct": false}
        ]
    }
}
```

### Current Default Question

**Question**: "Who is the person who creates the message in the communication process?"

**Answer**: A. Sender

**Options**:
- A. Sender ✓
- B. Receiver
- C. Listener
- D. Decoder
- E. Creates
- F. Receives
- G. Sends
- H. Interprets

### Available Questions

There are 20 English Communication questions available (`english_communication_q1` through `english_communication_q20`), covering topics such as:
- Communication basics (sender, receiver, message, channel)
- Encoding and decoding
- Verbal and nonverbal communication
- Communication process and context
- Communication principles (clarity, courtesy, conciseness)

### Adding New Questions

To add a new question:

1. Open `autoload/minigame_manager.gd`
2. Add a new entry to the `maze_configs` dictionary:

```gdscript
"your_question_id": {
    "question": {
        "text": "Your question text here?",
        "options": [
            {"letter": "A", "text": "First option", "correct": true},
            {"letter": "B", "text": "Second option", "correct": false},
            // ... up to 8 options (A-H)
        ]
    }
}
```

3. Set `"correct": true` for the right answer(s)
4. All other options should have `"correct": false`

**Important**: The system supports 1 or 2 correct answers per question. If you have 2 correct answers, make sure to add a second `1` marker (change one `W` to `2`) in the map.

## Integration with Dialogic

### Triggering the Minigame from Timelines

In any `.dtl` timeline file (located in `content/timelines/`), add:

```
[signal arg="start_minigame english_communication_q1"]
```

Replace `english_communication_q1` with any question ID.

### Timeline Locations

Dialogues are organized by chapter:
- **Chapter 1**: `content/timelines/Chapter 1/c1s1.dtl` - `c1s5.dtl`
- **Chapter 2**: `content/timelines/Chapter 2/c2s0.dtl` - `c2s6.dtl`
- **Chapter 3**: `content/timelines/Chapter 3/c3s0.dtl` - `c3s6.dtl`
- **Chapter 4**: `content/timelines/Chapter 4/c4s0.dtl` - `c4s6.dtl`
- **Chapter 5**: `content/timelines/Chapter 5/c5s0.dtl` - `c5s5.dtl`

### Example Timeline Integration

```
Conrad: Let's test your knowledge of communication!
[signal arg="start_minigame english_communication_q1"]
Conrad: Well done! You understand the basics of communication.
```

## UI Elements

### Right Panel Display

The question panel shows:
```
Question:
[Question text]

A. [Option A text]
B. [Option B text]
C. [Option C text]
D. [Option D text]
E. [Option E text]
F. [Option F text]
G. [Option G text]
H. [Option H text]

Collected: 0/1
```

### Maze Display

- **Collectibles**: Show only letters (A-H) in colored boxes
- **Player**: Controlled with arrow keys or WASD
- **Start Position**: Highlighted in green
- **Hearts**: Display current health (♥♥♥)
- **Score**: Shows current score (0, 100, 200, etc.)

### Feedback System

- **Correct Answer**: Green flash + "Correct! 'A'" message
- **Wrong Answer**: Red flash + "Wrong! 'B'" message + collectible removed
- **Game Over**: "Game Over" or "Victory!" message after 1.5 seconds

## Technical Details

### Answer Placement Algorithm

The game uses a randomization system:

1. **Separate Options**: Splits question options into correct and wrong arrays
2. **Shuffle Spots**: Randomizes the order of correct spots (`1`) and wrong spots (`W`)
3. **Place Correct**: Places correct answer letters at shuffled correct spots
4. **Place Wrong**: Places wrong answer letters at shuffled wrong spots

This ensures:
- The correct answer appears at different positions each game
- Wrong answers are distributed randomly
- Players can't memorize answer locations

### Player Movement

- **Controls**: Arrow keys or WASD
- **Speed**: 180 units/second
- **Collision**: Grid-locked movement with wall detection
- **Pathfinding**: BFS algorithm ensures all positions are reachable

### Collectible States

1. **Normal**: Bobbing animation, colored by question number
2. **Confirm**: Scale up + fade out (correct answer collected)
3. **Reject**: Shrink + turn red (wrong answer collected)

## Modification History

### Latest Changes (2026-01-30)

1. **Increased Maze Size**: Changed from 15×11 to 25×15 cells for more challenge
2. **Letter-Based Display**: Collectibles now show only letters (A-H) instead of full text
3. **Single Answer Support**: Adapted system to work with 1 correct answer questions
4. **Dynamic Answer Counting**: Game automatically detects how many correct answers exist
5. **Updated Default Question**: Set "Who is the person who creates the message..." as default
6. **All 20 Questions Added**: Full set of English communication questions implemented

### Previous Versions

- **Version 1.0**: Original 31×23 maze with 5-question format
- **Version 1.1**: Compact 15×11 maze with 2-blank fill-in-the-blank format
- **Version 2.0**: Current 25×15 maze with letter-based single-answer format

## Troubleshooting

### Common Issues

**Issue**: Player can't reach the correct answer
- **Solution**: Check that there's a valid path from `S` to `1` in the map

**Issue**: Wrong answers block the path to correct answer
- **Solution**: Place `W` markers away from the direct path between `S` and `1`

**Issue**: Minigame doesn't start from timeline
- **Solution**: Verify the signal syntax: `[signal arg="start_minigame question_id"]`

**Issue**: Too many/few answer collectibles
- **Solution**: Ensure you have exactly 7 `W` markers and 1 `1` marker in the map

### Debug Output

The game prints useful debug information:
- Loaded maze dimensions
- Start position coordinates
- Correct answer spot positions
- Wrong answer spot positions
- Placed answer letters and their positions

Check the Godot console output window for these messages.

## Future Enhancements

Potential improvements for future versions:

- [ ] Multiple map variants for variety
- [ ] Difficulty levels (easy/medium/hard maps)
- [ ] Time-based scoring bonus
- [ ] Power-ups (extra health, reveal correct answer, etc.)
- [ ] Animations for player movement
- [ ] Sound effects for movement and collection
- [ ] Mini-map display for larger mazes
- [ ] Support for 3+ correct answers per question

## Credits

- **Original Project**: EduMys Visual Novel
- **Maze System**: Custom implementation for educational purposes
- **Engine**: Godot 4.5
- **Dialogue System**: Dialogic 2.x

---

**Last Updated**: 2026-01-30
**Version**: 2.0
