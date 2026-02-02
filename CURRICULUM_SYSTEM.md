# Curriculum Question System Documentation

## Overview

The Curriculum Question System provides educational content for minigames based on the Philippine Senior High School curriculum. Questions are organized by subject, quarter, and minigame type, automatically selecting appropriate content based on the current chapter and selected subject.

## Architecture

### Core Files

- **Curriculum Database**: `autoload/curriculum_questions.gd` - Autoload singleton containing all curriculum questions
- **Minigame Manager**: `autoload/minigame_manager.gd` - Spawns minigames with curriculum configs
- **Signal Handler**: `scripts/dialogic_signal_handler.gd` - Handles minigame signals from timelines

### How It Works

```
Timeline Signal → DialogicSignalHandler → MinigameManager → CurriculumQuestions → Minigame
```

1. Timeline triggers: `[signal arg="start_minigame curriculum:runner"]`
2. DialogicSignalHandler pauses Dialogic and calls MinigameManager
3. MinigameManager extracts minigame type ("runner") from puzzle_id
4. CurriculumQuestions.get_config() retrieves questions based on:
   - `Dialogic.VAR.selected_subject` (e.g., "English")
   - `Dialogic.VAR.current_chapter` (1-5)
   - Quarter mapping (chapters 1-2 = Q1, chapter 3 = Q2, etc.)
5. Minigame spawns with the configuration
6. On completion, Dialogic unpauses

## Required Dialogic Variables

**CRITICAL:** These variables MUST be set at the start of each chapter:

```
set {current_chapter} = 2
set {selected_subject} = "English"
```

### Where to Set Variables

In each chapter's intro file (`c1s1.dtl`, `c2s0.dtl`, `c3s0.dtl`, etc.), add these at the top:

```
[signal arg="show_title_card 2"]
[background arg="..."]
set {current_chapter} = 2
set {selected_subject} = "English"
set {chapter2_score} = 0
```

### Why This Matters

Without these variables:
- `CurriculumQuestions.get_config()` returns an empty dictionary
- Minigame fails to start
- `minigame_completed` signal is emitted with `false`
- Game continues but minigame is skipped
- ⚠️ **Previously caused freezing** (fixed in 2026-02-02)

## Chapter-to-Quarter Mapping

```gdscript
func _chapter_to_quarter(chapter: int) -> String:
	match chapter:
		1, 2:
			return "Q1"  # First Quarter
		3:
			return "Q2"  # Second Quarter
		4:
			return "Q3"  # Third Quarter
		_:
			return "Q4"  # Fourth Quarter (Chapter 5+)
```

## Question Database Structure

Questions are organized hierarchically:

```
questions = {
	"Subject Name": {
		"Q1": {
			"runner": {
				"questions": [
					{"question": "...", "correct": "...", "wrong": [...]},
					...
				]
			},
			"pacman": {...},
			"maze": {...},
			...
		},
		"Q2": {...},
		...
	}
}
```

### Supported Subjects

Current subjects in `curriculum_questions.gd`:
- **General Mathematics** - Senior High School math curriculum
- **Earth Science** - Geology, climate, natural phenomena
- **Biology** - Cells, genetics, evolution
- **Chemistry** - Atoms, molecules, reactions
- **English** - Communication, speech acts, argumentation (Oral Communication in Context)

### Supported Minigame Types

- `runner` - Running quiz game
- `pacman` - Collect correct answers, avoid wrong ones
- `platformer` - Platform-based quiz
- `maze` - Navigate maze to find correct answers
- `fillinblank` - Fill-in-the-blank word puzzles
- `math` - Math problem solving

## Using Curriculum Minigames in Timelines

### Basic Usage

```
Conrad: Let's test your knowledge!
[signal arg="start_minigame curriculum:runner"]
Conrad: Well done!
```

### Full Example with Context

```
[background arg="res://Bg/classroom.png" fade="1.0"]
join Conrad (half) left
Conrad: Before we continue, let's review what you've learned.
join "Diwata Laya" (Half_mirror) center
[signal arg="laya_start"]
"Diwata Laya": Test your understanding with this challenge.
[signal arg="start_minigame curriculum:pacman"]
"Diwata Laya": Your knowledge grows stronger.
[signal arg="laya_end"]
leave "Diwata Laya"
Conrad: Excellent work! Now we can proceed.
```

### Multiple Minigames

Different minigame types can be used throughout a chapter:

```
# Scene 1 - Introduction
[signal arg="start_minigame curriculum:runner"]

# Scene 3 - Mid-chapter challenge
[signal arg="start_minigame curriculum:pacman"]

# Scene 5 - Final test
[signal arg="start_minigame curriculum:maze"]
```

## Adding New Curriculum Questions

### Step 1: Choose Subject, Quarter, and Type

Determine:
- **Subject**: Which subject does this content belong to?
- **Quarter**: Which quarter (Q1-Q4)?
- **Minigame Type**: Which minigame will use these questions?

### Step 2: Add Questions to Database

Open `autoload/curriculum_questions.gd` and locate the subject/quarter/type:

```gdscript
var questions = {
	"English": {
		"Q1": {
			"runner": {
				"questions": [
					// Add new questions here
					{
						"question": "What is communication?",
						"correct": "Exchange of ideas",
						"wrong": ["Speaking only", "Writing only", "Listening only"]
					},
					// ... more questions
				]
			}
		}
	}
}
```

### Step 3: Question Formats by Minigame Type

#### Runner, Pacman, Platformer Format

```gdscript
"runner": {
	"questions": [
		{
			"question": "Question text?",
			"correct": "Correct answer",
			"wrong": ["Wrong 1", "Wrong 2", "Wrong 3"]
		}
	]
}
```

#### Maze Format

```gdscript
"maze": {
	"question": {
		"text": "Question text?",
		"options": [
			{"letter": "A", "text": "Correct answer", "correct": true},
			{"letter": "B", "text": "Wrong answer 1", "correct": false},
			{"letter": "C", "text": "Wrong answer 2", "correct": false},
			{"letter": "D", "text": "Wrong answer 3", "correct": false}
			// Up to 8 options (A-H)
		]
	}
}
```

#### Fill-in-Blank Format

```gdscript
"fillinblank": {
	"sentence": "The ____ is the person who creates the message.",
	"blanks": [
		{
			"correct_word": "sender",
			"wrong_words": ["receiver", "decoder", "listener"]
		}
	]
}
```

### Step 4: Test the Questions

1. Set the correct subject and chapter in your timeline:
   ```
   set {selected_subject} = "English"
   set {current_chapter} = 1
   ```

2. Trigger the minigame:
   ```
   [signal arg="start_minigame curriculum:runner"]
   ```

3. Verify questions appear correctly and answers work

## Adding a New Subject

### Step 1: Create Subject Structure

```gdscript
var questions = {
	// ... existing subjects ...

	"New Subject Name": {
		"Q1": {
			"runner": {
				"questions": [...]
			},
			"pacman": {
				"questions": [...]
			}
		},
		"Q2": {...},
		"Q3": {...},
		"Q4": {...}
	}
}
```

### Step 2: Add Questions for Each Quarter

Ensure you have questions for at least:
- One minigame type per quarter
- Multiple questions per minigame (5-10 recommended)

### Step 3: Update Timeline Variables

In timelines where you want to use the new subject:

```
set {selected_subject} = "New Subject Name"
```

## Troubleshooting

### Issue: Minigame Freezes on Start

**Symptoms:**
- Game freezes when minigame should start
- Debug output shows: `No curriculum config for: runner`
- Pause menu unpauses but minigame is skipped

**Cause:** Required variables not set

**Solution:**
1. Check chapter intro file (`cNs0.dtl` or `cNs1.dtl`)
2. Add at the top:
   ```
   set {current_chapter} = N
   set {selected_subject} = "English"
   ```

### Issue: Questions Don't Match Subject

**Symptoms:**
- Wrong subject questions appear
- Questions seem random

**Cause:** Incorrect `selected_subject` variable

**Solution:**
1. Verify spelling: `"English"` not `"english"`
2. Check subject exists in `curriculum_questions.gd`
3. Ensure variable is set before minigame signal

### Issue: No Questions Found for Quarter

**Symptoms:**
- Empty config returned
- Debug warning: `No questions for quarter: Q2`

**Cause:** Missing quarter in subject

**Solution:**
1. Open `autoload/curriculum_questions.gd`
2. Find your subject
3. Add the missing quarter with questions:
   ```gdscript
   "Q2": {
   	"runner": {
   		"questions": [...]
   	}
   }
   ```

### Issue: Minigame Type Not Supported

**Symptoms:**
- Warning: `No runner for Subject/Quarter`

**Cause:** Minigame type missing from quarter

**Solution:**
Add the minigame type to that quarter's structure:
```gdscript
"Q1": {
	"runner": {  // Add this
		"questions": [...]
	}
}
```

## Best Practices

### Question Design

1. **Keep questions clear and concise** - Students should understand quickly
2. **Align with curriculum** - Match Philippine SHS standards
3. **Vary difficulty** - Mix easy, medium, and hard questions
4. **Avoid ambiguity** - One clearly correct answer
5. **Use distractors wisely** - Wrong answers should be plausible but clearly incorrect

### Content Organization

1. **Group by topic** - Keep related questions together
2. **Progress logically** - Order questions from basic to advanced
3. **Balance quantity** - 10-15 questions per minigame type per quarter
4. **Test thoroughly** - Verify all questions before deploying

### Performance

1. **Avoid huge question banks** - 20-30 questions per type is optimal
2. **Random selection** - Minigames randomly select from available questions
3. **Cache configs** - `get_config()` is called once per minigame

## Examples

### Adding English Q1 Runner Questions

```gdscript
"English": {
	"Q1": {
		"runner": {
			"questions": [
				{
					"question": "Who sends the message in communication?",
					"correct": "Sender",
					"wrong": ["Receiver", "Decoder", "Channel"]
				},
				{
					"question": "What is the response to a message called?",
					"correct": "Feedback",
					"wrong": ["Noise", "Channel", "Context"]
				},
				{
					"question": "What interferes with communication?",
					"correct": "Noise",
					"wrong": ["Feedback", "Sender", "Message"]
				}
			]
		}
	}
}
```

### Adding Math Q2 Maze Question

```gdscript
"General Mathematics": {
	"Q2": {
		"maze": {
			"question": {
				"text": "What is the derivative of x^2?",
				"options": [
					{"letter": "A", "text": "2x", "correct": true},
					{"letter": "B", "text": "x", "correct": false},
					{"letter": "C", "text": "x^2", "correct": false},
					{"letter": "D", "text": "2", "correct": false},
					{"letter": "E", "text": "0", "correct": false},
					{"letter": "F", "text": "x^3", "correct": false},
					{"letter": "G", "text": "2x^2", "correct": false},
					{"letter": "H", "text": "1", "correct": false}
				]
			}
		}
	}
}
```

## Related Documentation

- [CLAUDE.md](CLAUDE.md) - Overall architecture and patterns
- [MAZE_MINIGAME_DOCUMENTATION.md](MAZE_MINIGAME_DOCUMENTATION.md) - Detailed maze minigame guide
- [EVIDENCE_SYSTEM.md](EVIDENCE_SYSTEM.md) - Evidence collection system

---

**Last Updated**: 2026-02-02
**Version**: 1.0
