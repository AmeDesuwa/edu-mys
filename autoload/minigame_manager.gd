extends Node

signal minigame_completed(puzzle_id: String, success: bool)

# Minigame scenes
var fillinblank_scene = preload("res://minigames/Drag/scenes/FillInTheBlank.tscn")
var pacman_scene = preload("res://minigames/Pacman/scenes/Main.tscn")
var runner_scene = preload("res://minigames/Runner/scenes/Main.tscn")
var platformer_scene = preload("res://minigames/Platformer/scenes/Main.tscn")
var maze_scene = preload("res://minigames/Maze/scenes/Main.tscn")
var pronunciation_scene = preload("res://minigames/Pronunciation/scenes/Main.tscn")
var current_minigame = null

# Fill-in-the-blank puzzle configs
var fillinblank_configs = {
	"timeline_deduction": {
		"sentence_parts": ["The scientific method starts with ", " and ends with a ", "."],
		"answers": ["observation", "conclusion"],
		"choices": ["observation", "experiment", "conclusion", "hypothesis", "question", "theory", "analysis", "research"]
	},
	"evidence_analysis": {
		"sentence_parts": ["In a court of law, the ", " must prove guilt beyond reasonable ", "."],
		"answers": ["prosecution", "doubt"],
		"choices": ["prosecution", "defense", "doubt", "evidence", "judge", "jury", "witness", "question"]
	},
	"statement_analysis": {
		"sentence_parts": ["Critical thinking requires ", " evidence before forming a ", "."],
		"answers": ["evaluating", "judgment"],
		"choices": ["evaluating", "ignoring", "judgment", "question", "collecting", "opinion", "belief", "theory"]
	},
	"budget_basics": {
		"sentence_parts": ["A budget helps track ", " and ", " to manage money wisely."],
		"answers": ["income", "expenses"],
		"choices": ["income", "expenses", "savings", "debts", "profits", "losses", "assets", "taxes"]
	},
	# Chapter 3 - Art vocabulary
	"art_vocabulary": {
		"sentence_parts": ["In art, the arrangement of elements is called ", " and the contrast between light and dark is ", "."],
		"answers": ["composition", "value"],
		"choices": ["composition", "value", "texture", "color", "balance", "rhythm", "emphasis", "form"]
	},
	# Chapter 4 - Library access logic
	"library_logic": {
		"sentence_parts": ["To solve the case, Conrad must analyze ", " and identify ", " to find the truth."],
		"answers": ["patterns", "evidence"],
		"choices": ["patterns", "evidence", "suspects", "motives", "alibis", "witnesses", "clues", "facts"]
	},
	# Chapter 5 - Lesson reflection
	"lesson_reflection": {
		"sentence_parts": ["True teaching requires ", " and respects ", " while guiding growth."],
		"answers": ["wisdom", "choice"],
		"choices": ["wisdom", "choice", "control", "force", "patience", "freedom", "power", "authority"]
	}
}

# Pacman quiz puzzle configs
var pacman_configs = {
	"pacman_science": {
		"questions": [
			{
				"question": "What is the chemical symbol for water?",
				"correct": "H2O",
				"wrong": ["CO2", "NaCl", "O2"]
			},
			{
				"question": "Which planet is known as the Red Planet?",
				"correct": "Mars",
				"wrong": ["Venus", "Jupiter", "Saturn"]
			},
			{
				"question": "What gas do plants absorb from the atmosphere?",
				"correct": "Carbon Dioxide",
				"wrong": ["Oxygen", "Nitrogen", "Hydrogen"]
			},
			{
				"question": "What is the largest organ in the human body?",
				"correct": "Skin",
				"wrong": ["Heart", "Liver", "Brain"]
			}
		]
	},
	"pacman_history": {
		"questions": [
			{
				"question": "Who was the first President of the United States?",
				"correct": "Washington",
				"wrong": ["Lincoln", "Jefferson", "Adams"]
			},
			{
				"question": "In what year did World War II end?",
				"correct": "1945",
				"wrong": ["1944", "1946", "1943"]
			},
			{
				"question": "Which ancient civilization built the pyramids?",
				"correct": "Egyptians",
				"wrong": ["Romans", "Greeks", "Mayans"]
			},
			{
				"question": "What was the name of the ship that brought Pilgrims to America?",
				"correct": "Mayflower",
				"wrong": ["Santa Maria", "Endeavour", "Victory"]
			}
		]
	},
	"pacman_math": {
		"questions": [
			{
				"question": "What is 15 x 4?",
				"correct": "60",
				"wrong": ["45", "55", "70"]
			},
			{
				"question": "What is the square root of 144?",
				"correct": "12",
				"wrong": ["11", "13", "14"]
			},
			{
				"question": "What is 7 + 8 x 2?",
				"correct": "23",
				"wrong": ["30", "22", "16"]
			},
			{
				"question": "How many sides does a hexagon have?",
				"correct": "6",
				"wrong": ["5", "7", "8"]
			}
		]
	}
}

# Runner quiz configs
var runner_configs = {
	"runner_geography": {
		"questions": [
			{
				"question": "What is the capital of Japan?",
				"correct": "Tokyo",
				"wrong": ["Osaka", "Kyoto", "Hiroshima"]
			},
			{
				"question": "Which continent is the Sahara Desert located in?",
				"correct": "Africa",
				"wrong": ["Asia", "Australia", "South America"]
			},
			{
				"question": "What is the longest river in the world?",
				"correct": "Nile",
				"wrong": ["Amazon", "Yangtze", "Mississippi"]
			},
			{
				"question": "Which country has the largest population?",
				"correct": "China",
				"wrong": ["India", "USA", "Indonesia"]
			},
			{
				"question": "What is the smallest country in the world?",
				"correct": "Vatican City",
				"wrong": ["Monaco", "San Marino", "Liechtenstein"]
			}
		],
		"answers_needed": 4
	},
	"runner_science": {
		"questions": [
			{
				"question": "What is the speed of light in km/s?",
				"correct": "300,000",
				"wrong": ["150,000", "500,000", "1,000,000"]
			},
			{
				"question": "What planet has the most moons?",
				"correct": "Saturn",
				"wrong": ["Jupiter", "Uranus", "Neptune"]
			},
			{
				"question": "What is the hardest natural substance?",
				"correct": "Diamond",
				"wrong": ["Gold", "Iron", "Titanium"]
			},
			{
				"question": "How many bones are in the adult human body?",
				"correct": "206",
				"wrong": ["186", "216", "256"]
			},
			{
				"question": "What is the chemical symbol for gold?",
				"correct": "Au",
				"wrong": ["Go", "Gd", "Ag"]
			}
		],
		"answers_needed": 4
	},
	"runner_literature": {
		"questions": [
			{
				"question": "Who wrote 'Romeo and Juliet'?",
				"correct": "Shakespeare",
				"wrong": ["Dickens", "Austen", "Twain"]
			},
			{
				"question": "What is the name of Harry Potter's owl?",
				"correct": "Hedwig",
				"wrong": ["Errol", "Pigwidgeon", "Scabbers"]
			},
			{
				"question": "In which book does the character Gandalf appear?",
				"correct": "Lord of Rings",
				"wrong": ["Narnia", "Harry Potter", "Eragon"]
			},
			{
				"question": "Who wrote 'The Great Gatsby'?",
				"correct": "Fitzgerald",
				"wrong": ["Hemingway", "Steinbeck", "Faulkner"]
			},
			{
				"question": "What is the first book of the Bible?",
				"correct": "Genesis",
				"wrong": ["Exodus", "Leviticus", "Matthew"]
			}
		],
		"answers_needed": 4
	}
}

# Platformer quiz configs
var platformer_configs = {
	"platformer_math": {
		"questions": [
			{
				"question": "What is 9 x 6?",
				"correct": "54",
				"wrong": ["45", "56", "63"]
			},
			{
				"question": "What is 144 / 12?",
				"correct": "12",
				"wrong": ["11", "13", "14"]
			},
			{
				"question": "What is 25 + 37?",
				"correct": "62",
				"wrong": ["52", "72", "63"]
			},
			{
				"question": "What is 100 - 47?",
				"correct": "53",
				"wrong": ["43", "57", "63"]
			}
		],
		"answers_needed": 3
	},
	"platformer_nature": {
		"questions": [
			{
				"question": "What do bees make?",
				"correct": "Honey",
				"wrong": ["Milk", "Silk", "Wax"]
			},
			{
				"question": "How many legs does an insect have?",
				"correct": "6",
				"wrong": ["4", "8", "10"]
			},
			{
				"question": "What is the largest mammal?",
				"correct": "Blue Whale",
				"wrong": ["Elephant", "Giraffe", "Hippo"]
			},
			{
				"question": "What gas do we breathe in?",
				"correct": "Oxygen",
				"wrong": ["Nitrogen", "Carbon", "Helium"]
			}
		],
		"answers_needed": 3
	},
	"platformer_history": {
		"questions": [
			{
				"question": "Who discovered America?",
				"correct": "Columbus",
				"wrong": ["Magellan", "Cook", "Drake"]
			},
			{
				"question": "What year did WW1 start?",
				"correct": "1914",
				"wrong": ["1912", "1916", "1918"]
			},
			{
				"question": "Who was the first man on the moon?",
				"correct": "Armstrong",
				"wrong": ["Aldrin", "Glenn", "Gagarin"]
			},
			{
				"question": "What empire built the Colosseum?",
				"correct": "Roman",
				"wrong": ["Greek", "Egyptian", "Persian"]
			}
		],
		"answers_needed": 3
	}
}

# Maze puzzle configs - questions shown in order, player plans route through maze
var maze_configs = {
	"maze_deduction": {
		"questions": [
			{"question": "What comes after 'observation' in the scientific method?", "correct": "Hypothesis", "wrong": ["Conclusion", "Experiment", "Theory"]},
			{"question": "What type of reasoning goes from general to specific?", "correct": "Deductive", "wrong": ["Inductive", "Abductive", "Circular"]},
			{"question": "What do we call a testable prediction?", "correct": "Hypothesis", "wrong": ["Fact", "Opinion", "Law"]},
			{"question": "What confirms or denies a hypothesis?", "correct": "Evidence", "wrong": ["Belief", "Assumption", "Guess"]},
			{"question": "What is the final step of the scientific method?", "correct": "Conclusion", "wrong": ["Question", "Research", "Hypothesis"]}
		]
	},
	"maze_logic": {
		"questions": [
			{"question": "If A implies B, and A is true, what is B?", "correct": "True", "wrong": ["False", "Unknown", "Neither"]},
			{"question": "What is the opposite of 'all'?", "correct": "None", "wrong": ["Some", "Most", "Few"]},
			{"question": "A AND B is true when?", "correct": "Both true", "wrong": ["One true", "Both false", "Either true"]},
			{"question": "A OR B is false when?", "correct": "Both false", "wrong": ["One false", "Both true", "One true"]},
			{"question": "What is NOT true?", "correct": "False", "wrong": ["Maybe", "True", "Unknown"]}
		]
	},
	"maze_vocabulary": {
		"questions": [
			{"question": "A word that means the same is called a?", "correct": "Synonym", "wrong": ["Antonym", "Homonym", "Acronym"]},
			{"question": "A word that means the opposite is called a?", "correct": "Antonym", "wrong": ["Synonym", "Homonym", "Acronym"]},
			{"question": "Words that sound the same are called?", "correct": "Homophones", "wrong": ["Synonyms", "Antonyms", "Metaphors"]},
			{"question": "The main character in a story is the?", "correct": "Protagonist", "wrong": ["Antagonist", "Narrator", "Author"]},
			{"question": "A comparison using 'like' or 'as' is a?", "correct": "Simile", "wrong": ["Metaphor", "Hyperbole", "Irony"]}
		]
	}
}

# Pronunciation puzzle configs - K-12 English Oral Communications
var pronunciation_configs = {
	# Basic articulation and clarity
	"oral_greeting": {
		"sentence": "good morning everyone my name is conrad",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oral_introduction": {
		"sentence": "today i will talk about an important topic",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	# Presentation skills
	"oral_transition": {
		"sentence": "now let us move on to the next point",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oral_conclusion": {
		"sentence": "in conclusion we have learned three key ideas",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	# Reading fluency
	"oral_fluency_1": {
		"sentence": "the quick brown fox jumps over the lazy dog",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oral_fluency_2": {
		"sentence": "she sells seashells by the seashore",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	# Expression and emphasis
	"oral_question": {
		"sentence": "what do you think is the best solution",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oral_persuasion": {
		"sentence": "i believe we should work together as a team",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	# Formal speaking
	"oral_formal": {
		"sentence": "thank you for giving me this opportunity to speak",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	# Storytelling
	"oral_narrative": {
		"sentence": "once upon a time there lived a brave young hero",
		"min_confidence": 0.6,
		"max_attempts": 3
	}
}

func start_minigame(puzzle_id: String) -> void:
	print("DEBUG: MinigameManager.start_minigame called with: ", puzzle_id)
	if current_minigame:
		push_warning("Minigame already active!")
		return

	# Check which type of minigame this is
	if fillinblank_configs.has(puzzle_id):
		_start_fillinblank(puzzle_id)
	elif pacman_configs.has(puzzle_id):
		_start_pacman(puzzle_id)
	elif runner_configs.has(puzzle_id):
		_start_runner(puzzle_id)
	elif platformer_configs.has(puzzle_id):
		_start_platformer(puzzle_id)
	elif maze_configs.has(puzzle_id):
		_start_maze(puzzle_id)
	elif pronunciation_configs.has(puzzle_id):
		_start_pronunciation(puzzle_id)
	else:
		push_error("Unknown puzzle: " + puzzle_id)
		return

func _start_fillinblank(puzzle_id: String) -> void:
	print("DEBUG: Starting fill-in-the-blank minigame...")
	current_minigame = fillinblank_scene.instantiate()
	get_tree().root.add_child(current_minigame)
	current_minigame.configure_puzzle(fillinblank_configs[puzzle_id])
	current_minigame.game_finished.connect(_on_minigame_finished.bind(puzzle_id))
	print("DEBUG: Fill-in-the-blank minigame should now be visible")

func _start_pacman(puzzle_id: String) -> void:
	print("DEBUG: Starting Pacman minigame...")
	current_minigame = pacman_scene.instantiate()
	get_tree().root.add_child(current_minigame)
	current_minigame.configure_puzzle(pacman_configs[puzzle_id])
	current_minigame.game_finished.connect(_on_minigame_finished.bind(puzzle_id))
	print("DEBUG: Pacman minigame should now be visible")

func _start_runner(puzzle_id: String) -> void:
	print("DEBUG: Starting Runner minigame...")
	current_minigame = runner_scene.instantiate()
	get_tree().root.add_child(current_minigame)
	current_minigame.configure_puzzle(runner_configs[puzzle_id])
	current_minigame.game_finished.connect(_on_minigame_finished.bind(puzzle_id))
	print("DEBUG: Runner minigame should now be visible")

func _start_platformer(puzzle_id: String) -> void:
	print("DEBUG: Starting Platformer minigame...")
	current_minigame = platformer_scene.instantiate()
	get_tree().root.add_child(current_minigame)
	current_minigame.configure_puzzle(platformer_configs[puzzle_id])
	current_minigame.game_finished.connect(_on_minigame_finished.bind(puzzle_id))
	print("DEBUG: Platformer minigame should now be visible")

func _start_maze(puzzle_id: String) -> void:
	print("DEBUG: Starting Maze minigame...")
	current_minigame = maze_scene.instantiate()
	get_tree().root.add_child(current_minigame)
	# The maze scene has Main (CanvasLayer) > Game (Node2D with script)
	var game_node = current_minigame.get_node("Game")
	game_node.configure_puzzle(maze_configs[puzzle_id])
	game_node.game_finished.connect(_on_minigame_finished.bind(puzzle_id))
	print("DEBUG: Maze minigame should now be visible")

func _start_pronunciation(puzzle_id: String) -> void:
	print("DEBUG: Starting Pronunciation minigame...")
	current_minigame = pronunciation_scene.instantiate()
	get_tree().root.add_child(current_minigame)
	current_minigame.configure_puzzle(pronunciation_configs[puzzle_id])
	current_minigame.game_finished.connect(_on_minigame_finished.bind(puzzle_id))
	print("DEBUG: Pronunciation minigame should now be visible")

func _on_minigame_finished(success: bool, score: int, puzzle_id: String) -> void:
	print("DEBUG: Minigame finished. Success: ", success, ", Score: ", score, ", Puzzle: ", puzzle_id)
	if success:
		Dialogic.VAR.minigames_completed += 1
	minigame_completed.emit(puzzle_id, success)
	current_minigame = null
