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

# ========================================
# ORAL COMMUNICATION MODULE QUIZ CONFIGS
# ========================================

# Module 1: Functions, Nature, and Process of Communication
var oralcom_module1_configs = {
	"oralcom_m1_pacman": {
		"questions": [
			{"question": "What is the exchange of information, ideas, or feelings between people?", "correct": "Communication", "wrong": ["Language", "Interaction", "Conversation"]},
			{"question": "Who is the person that starts or creates the message?", "correct": "Sender", "wrong": ["Receiver", "Decoder", "Listener"]},
			{"question": "Who receives and interprets the message?", "correct": "Receiver", "wrong": ["Speaker", "Sender", "Encoder"]},
			{"question": "What is the idea or information being communicated?", "correct": "Message", "wrong": ["Feedback", "Channel", "Noise"]}
		]
	},
	"oralcom_m1_runner": {
		"questions": [
			{"question": "What is the process of converting ideas into words or symbols?", "correct": "Encoding", "wrong": ["Decoding", "Feedback", "Noise"]},
			{"question": "What is the process of interpreting the message?", "correct": "Decoding", "wrong": ["Encoding", "Sending", "Responding"]},
			{"question": "What is the medium used to transmit the message?", "correct": "Channel", "wrong": ["Context", "Message", "Noise"]},
			{"question": "What is the response given by the receiver?", "correct": "Feedback", "wrong": ["Message", "Channel", "Noise"]},
			{"question": "What refers to anything that interferes with communication?", "correct": "Noise", "wrong": ["Context", "Feedback", "Channel"]}
		],
		"answers_needed": 4
	},
	"oralcom_m1_platformer": {
		"questions": [
			{"question": "What type of communication uses spoken or written words?", "correct": "Verbal", "wrong": ["Nonverbal", "Oral", "Visual"]},
			{"question": "What type of communication uses body language and facial expressions?", "correct": "Nonverbal", "wrong": ["Oral", "Written", "Verbal"]},
			{"question": "What refers to the characteristics that describe how communication works?", "correct": "Nature", "wrong": ["Function", "Process", "Context"]},
			{"question": "What is the continuous exchange between sender and receiver?", "correct": "Process", "wrong": ["Channel", "Encoding", "Feedback"]}
		],
		"answers_needed": 3
	},
	"oralcom_m1_maze": {
		"questions": [
			{"question": "What type of communication is clear and understood by the receiver?", "correct": "Effective", "wrong": ["Verbal", "Formal", "Correct"]},
			{"question": "What refers to the purpose of communication?", "correct": "Function", "wrong": ["Channel", "Nature", "Process"]},
			{"question": "What refers to the situation or environment where communication occurs?", "correct": "Context", "wrong": ["Channel", "Noise", "Message"]},
			{"question": "What means expressing ideas clearly and understandably?", "correct": "Clarity", "wrong": ["Courtesy", "Conciseness", "Correctness"]},
			{"question": "What refers to politeness and respect in communication?", "correct": "Courtesy", "wrong": ["Clarity", "Conciseness", "Correctness"]}
		]
	}
}

# Module 2: Models of Communication
var oralcom_module2_configs = {
	"oralcom_m2_pacman": {
		"questions": [
			{"question": "What refers to a visual representation of how communication works?", "correct": "Diagram", "wrong": ["Speech", "Message", "Language"]},
			{"question": "Which model shows communication as a one-way process?", "correct": "Linear", "wrong": ["Interactive", "Transactional", "Circular"]},
			{"question": "Which model includes feedback from the receiver?", "correct": "Interactive", "wrong": ["Linear", "Passive", "Static"]},
			{"question": "Which model shows participants as simultaneous sender and receiver?", "correct": "Transactional", "wrong": ["Linear", "Interactive", "Sequential"]}
		]
	},
	"oralcom_m2_runner": {
		"questions": [
			{"question": "Who developed the Shannon-Weaver model?", "correct": "Shannon", "wrong": ["Aristotle", "Berlo", "Schramm"]},
			{"question": "What refers to interference in communication?", "correct": "Noise", "wrong": ["Channel", "Feedback", "Context"]},
			{"question": "Who starts the communication process?", "correct": "Sender", "wrong": ["Receiver", "Decoder", "Listener"]},
			{"question": "Who receives and interprets the message?", "correct": "Receiver", "wrong": ["Sender", "Encoder", "Speaker"]},
			{"question": "Which model emphasizes shared experience?", "correct": "Schramm", "wrong": ["Aristotle", "Shannon", "Linear"]}
		],
		"answers_needed": 4
	},
	"oralcom_m2_platformer": {
		"questions": [
			{"question": "Which model focuses on public speaking?", "correct": "Aristotle", "wrong": ["Interactive", "Transactional", "Circular"]},
			{"question": "What refers to the medium used to transmit messages?", "correct": "Channel", "wrong": ["Message", "Feedback", "Noise"]},
			{"question": "What refers to the content of communication?", "correct": "Message", "wrong": ["Context", "Noise", "Feedback"]},
			{"question": "What refers to the receiver's response?", "correct": "Feedback", "wrong": ["Channel", "Noise", "Encoding"]}
		],
		"answers_needed": 3
	},
	"oralcom_m2_maze": {
		"questions": [
			{"question": "Which model is commonly used in mass communication?", "correct": "Linear", "wrong": ["Transactional", "Interactive", "Circular"]},
			{"question": "Which model allows turn-taking?", "correct": "Interactive", "wrong": ["Linear", "Aristotle", "Passive"]},
			{"question": "What refers to the situation of communication?", "correct": "Context", "wrong": ["Noise", "Channel", "Message"]},
			{"question": "Which model views communication as dynamic?", "correct": "Transactional", "wrong": ["Linear", "Interactive", "Mechanical"]},
			{"question": "Which model highlights fields of experience?", "correct": "Schramm", "wrong": ["Aristotle", "Shannon", "Linear"]}
		]
	}
}

# Module 3: Strategies to Avoid Communication Breakdown
var oralcom_module3_configs = {
	"oralcom_m3_pacman": {
		"questions": [
			{"question": "What refers to the failure of communication?", "correct": "Breakdown", "wrong": ["Clarity", "Feedback", "Context"]},
			{"question": "What strategy involves paying full attention to the speaker?", "correct": "Listening", "wrong": ["Speaking", "Reading", "Writing"]},
			{"question": "What refers to asking questions to ensure understanding?", "correct": "Clarification", "wrong": ["Encoding", "Noise", "Feedback"]},
			{"question": "What helps reduce misunderstanding?", "correct": "Feedback", "wrong": ["Ambiguity", "Silence", "Noise"]}
		]
	},
	"oralcom_m3_runner": {
		"questions": [
			{"question": "What refers to expressing ideas clearly?", "correct": "Clarity", "wrong": ["Courtesy", "Context", "Conciseness"]},
			{"question": "What strategy involves showing respect to the listener?", "correct": "Courtesy", "wrong": ["Volume", "Speed", "Gesture"]},
			{"question": "What refers to shortening messages without losing meaning?", "correct": "Conciseness", "wrong": ["Clarity", "Completeness", "Correctness"]},
			{"question": "What causes misunderstanding in communication?", "correct": "Noise", "wrong": ["Feedback", "Context", "Clarity"]},
			{"question": "What refers to the situation where communication occurs?", "correct": "Context", "wrong": ["Channel", "Feedback", "Message"]}
		],
		"answers_needed": 4
	},
	"oralcom_m3_platformer": {
		"questions": [
			{"question": "What strategy involves adjusting language to the audience?", "correct": "Adaptation", "wrong": ["Encoding", "Decoding", "Noise"]},
			{"question": "What refers to responding to confirm understanding?", "correct": "Feedback", "wrong": ["Channel", "Noise", "Message"]},
			{"question": "What refers to polite language use?", "correct": "Courtesy", "wrong": ["Clarity", "Volume", "Speed"]},
			{"question": "What refers to listening with understanding?", "correct": "Listening", "wrong": ["Hearing", "Speaking", "Writing"]}
		],
		"answers_needed": 3
	},
	"oralcom_m3_maze": {
		"questions": [
			{"question": "What refers to correcting misunderstandings?", "correct": "Clarification", "wrong": ["Silence", "Noise", "Context"]},
			{"question": "What prevents confusion?", "correct": "Clarity", "wrong": ["Ambiguity", "Noise", "Speed"]},
			{"question": "What strategy avoids using unnecessary words?", "correct": "Conciseness", "wrong": ["Courtesy", "Completeness", "Adaptation"]},
			{"question": "What occurs when the message is unclear?", "correct": "Breakdown", "wrong": ["Success", "Understanding", "Adaptation"]},
			{"question": "What strategy helps confirm message accuracy?", "correct": "Feedback", "wrong": ["Noise", "Silence", "Ambiguity"]}
		]
	}
}

# Module 4: Oral Communication Activities
var oralcom_module4_configs = {
	"oralcom_m4_pacman": {
		"questions": [
			{"question": "What refers to spoken interaction between two or more people?", "correct": "Communication", "wrong": ["Writing", "Speaking", "Listening"]},
			{"question": "What oral activity involves sharing personal experiences?", "correct": "Storytelling", "wrong": ["Reporting", "Interviewing", "Debating"]},
			{"question": "What oral activity involves asking and answering questions?", "correct": "Interview", "wrong": ["Debate", "Speech", "Reporting"]},
			{"question": "What oral activity involves expressing opinions on an issue?", "correct": "Debating", "wrong": ["Reporting", "Narrating", "Listening"]}
		]
	},
	"oralcom_m4_runner": {
		"questions": [
			{"question": "What oral activity aims to inform an audience?", "correct": "Reporting", "wrong": ["Persuading", "Entertaining", "Arguing"]},
			{"question": "What oral activity involves sharing ideas to a group?", "correct": "Speaking", "wrong": ["Listening", "Writing", "Reading"]},
			{"question": "What oral activity uses voice and gestures?", "correct": "Speaking", "wrong": ["Writing", "Reading", "Typing"]},
			{"question": "What oral activity involves attentive hearing?", "correct": "Listening", "wrong": ["Speaking", "Reading", "Writing"]},
			{"question": "What oral activity focuses on audience understanding?", "correct": "Feedback", "wrong": ["Clarity", "Courtesy", "Context"]}
		],
		"answers_needed": 4
	},
	"oralcom_m4_platformer": {
		"questions": [
			{"question": "What oral activity involves sharing information formally?", "correct": "Reporting", "wrong": ["Interview", "Storytelling", "Debating"]},
			{"question": "What refers to planned oral activities?", "correct": "Controlled", "wrong": ["Random", "Casual", "Unplanned"]},
			{"question": "What refers to spontaneous oral activities?", "correct": "Uncontrolled", "wrong": ["Controlled", "Formal", "Planned"]},
			{"question": "What oral activity involves telling events in sequence?", "correct": "Storytelling", "wrong": ["Interview", "Reporting", "Debating"]}
		],
		"answers_needed": 3
	},
	"oralcom_m4_maze": {
		"questions": [
			{"question": "What oral activity involves exchanging ideas politely?", "correct": "Discussion", "wrong": ["Listening", "Writing", "Reading"]},
			{"question": "What oral activity allows sharing viewpoints?", "correct": "Discussion", "wrong": ["Silence", "Listening", "Reading"]},
			{"question": "What helps improve oral communication activities?", "correct": "Practice", "wrong": ["Noise", "Silence", "Speed"]},
			{"question": "What oral activity requires clear pronunciation?", "correct": "Speaking", "wrong": ["Writing", "Reading", "Typing"]},
			{"question": "What oral activity improves communication skills?", "correct": "Practice", "wrong": ["Avoidance", "Silence", "Noise"]}
		]
	}
}

# Module 5: Types of Speech Context
var oralcom_module5_configs = {
	"oralcom_m5_pacman": {
		"questions": [
			{"question": "Communication that happens within oneself is called?", "correct": "Intrapersonal", "wrong": ["Interpersonal", "Public", "Mass"]},
			{"question": "Communication between two or more people is called?", "correct": "Interpersonal", "wrong": ["Intrapersonal", "Public", "Mass"]},
			{"question": "Communication delivered to a large audience at once is?", "correct": "Mass", "wrong": ["Public", "Interpersonal", "Intrapersonal"]},
			{"question": "Communication addressed to a smaller audience or group is?", "correct": "Public", "wrong": ["Interpersonal", "Mass", "Intrapersonal"]}
		]
	},
	"oralcom_m5_runner": {
		"questions": [
			{"question": "What refers to the situation where communication occurs?", "correct": "Context", "wrong": ["Audience", "Feedback", "Noise"]},
			{"question": "Who receives the message in communication?", "correct": "Audience", "wrong": ["Sender", "Feedback", "Noise"]},
			{"question": "What shows if the message is understood?", "correct": "Feedback", "wrong": ["Context", "Noise", "Channel"]},
			{"question": "Communication that is organized and professional is called?", "correct": "Formal", "wrong": ["Informal", "Casual", "Personal"]},
			{"question": "Communication that is casual and relaxed is?", "correct": "Informal", "wrong": ["Formal", "Public", "Mass"]}
		],
		"answers_needed": 4
	},
	"oralcom_m5_platformer": {
		"questions": [
			{"question": "What describes communication that is clear and successful?", "correct": "Effective", "wrong": ["Noise", "Ambiguous", "Context"]},
			{"question": "Communication that happens in your mind is?", "correct": "Intrapersonal", "wrong": ["Interpersonal", "Public", "Mass"]},
			{"question": "Communication that happens between classmates is?", "correct": "Interpersonal", "wrong": ["Public", "Intrapersonal", "Mass"]},
			{"question": "Speaking in front of a classroom is what type?", "correct": "Public", "wrong": ["Mass", "Interpersonal", "Intrapersonal"]}
		],
		"answers_needed": 3
	},
	"oralcom_m5_maze": {
		"questions": [
			{"question": "Broadcasting a message to thousands is what type?", "correct": "Mass", "wrong": ["Interpersonal", "Intrapersonal", "Public"]},
			{"question": "The listeners or viewers in communication are called?", "correct": "Audience", "wrong": ["Sender", "Feedback", "Channel"]},
			{"question": "The response from the audience is called?", "correct": "Feedback", "wrong": ["Noise", "Channel", "Message"]},
			{"question": "Communication done during ceremonies or official events is?", "correct": "Formal", "wrong": ["Informal", "Mass", "Casual"]},
			{"question": "Communication that succeeds in delivering meaning is?", "correct": "Effective", "wrong": ["Noise", "Context", "Feedback"]}
		]
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
	# Story-related pronunciation challenges
	"focus_test": {
		"sentence": "i will focus my mind and find the truth",
		"prompt": "Prove your focus: Say 'I will focus my mind and find the truth.'",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
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
	},

	# ========================================
	# ORAL COMMUNICATION MODULE SPEECH RECOGNITION
	# ========================================

	# Module 1: Subject-Verb Agreement & Grammar
	"oralcom_m1_grammar_1": {
		"sentence": "she goes to school every day",
		"prompt": "Say the sentence using the correct verb form: 'She ___ (go) to school every day.'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m1_grammar_2": {
		"sentence": "yesterday i finished my homework",
		"prompt": "Say the sentence using the correct past tense: 'Yesterday, I ___ (finish) my homework.'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m1_grammar_3": {
		"sentence": "this gift is for me",
		"prompt": "Say the sentence using the correct pronoun: 'This gift is for ___.'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m1_grammar_4": {
		"sentence": "he is always on time",
		"prompt": "Rearrange and say the sentence correctly: 'always / on time / is / he'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m1_grammar_5": {
		"sentence": "she adopted an honest dog",
		"prompt": "Say the sentence using the correct article: 'She adopted ___ honest dog.'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},

	# Module 2: Models of Communication Grammar
	"oralcom_m2_grammar_1": {
		"sentence": "the linear model shows one way communication",
		"prompt": "Say the sentence correctly: 'The linear model ___ (show) one-way communication.'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m2_grammar_2": {
		"sentence": "the interactive model includes feedback",
		"prompt": "Say the sentence using the correct article: '___ interactive model includes feedback.'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m2_grammar_3": {
		"sentence": "the transactional model includes feedback",
		"prompt": "Arrange and say correctly: 'includes / transactional / feedback / model / the'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m2_grammar_4": {
		"sentence": "communication noise interrupts understanding",
		"prompt": "Say using correct present tense: 'Communication noise ___ (interrupt) understanding.'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m2_grammar_5": {
		"sentence": "feedback is important because it shows understanding",
		"prompt": "Complete and say: 'Feedback is important because ___.'",
		"min_confidence": 0.5,
		"max_attempts": 3
	},

	# Module 3: Avoiding Communication Breakdown Grammar
	"oralcom_m3_grammar_1": {
		"sentence": "clear communication helps avoid misunderstanding",
		"prompt": "Say correctly: 'Clear communication ___ (help) avoid misunderstanding.'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m3_grammar_2": {
		"sentence": "speakers should listen carefully to their audience",
		"prompt": "Say using correct modal verb: 'Speakers ___ listen carefully to their audience.'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m3_grammar_3": {
		"sentence": "asking for clarification prevents misunderstanding",
		"prompt": "Rearrange and say: 'asking / clarification / prevents / misunderstanding'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m3_grammar_4": {
		"sentence": "miscommunication occurs when the message is unclear",
		"prompt": "Say using correct present tense: 'Miscommunication ___ (occur) when the message is unclear.'",
		"min_confidence": 0.6,
		"max_attempts": 3
	},
	"oralcom_m3_grammar_5": {
		"sentence": "communication breakdown happens when the message is not understood",
		"prompt": "Complete and say: 'Communication breakdown happens when ___.'",
		"min_confidence": 0.5,
		"max_attempts": 3
	},

	# Module 4: Oral Communication Activities - Word Usage
	"oralcom_m4_word_storytelling": {
		"sentence": "storytelling helps share personal experiences with the audience",
		"prompt": "Use the word STORYTELLING in a sentence about oral communication.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m4_word_interview": {
		"sentence": "an interview allows people to ask and answer questions",
		"prompt": "Use the word INTERVIEW in a grammatically correct sentence.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m4_word_debating": {
		"sentence": "debating helps students express their opinions clearly",
		"prompt": "Use the word DEBATING in a sentence.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m4_word_reporting": {
		"sentence": "reporting shares important information with the audience",
		"prompt": "Use the word REPORTING in a sentence.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m4_word_practice": {
		"sentence": "practice helps improve your oral communication skills",
		"prompt": "Use the word PRACTICE in a sentence about improving oral communication.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},

	# Module 5: Types of Speech Context - Word Usage
	"oralcom_m5_word_intrapersonal": {
		"sentence": "intrapersonal communication happens when i reflect on my own thoughts",
		"prompt": "Use INTRAPERSONAL in a sentence.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m5_word_interpersonal": {
		"sentence": "interpersonal communication occurs when i talk with my friend",
		"prompt": "Use INTERPERSONAL in a sentence.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m5_word_public": {
		"sentence": "public communication happens when the teacher speaks to the class",
		"prompt": "Use PUBLIC in a sentence about communication.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m5_word_mass": {
		"sentence": "mass communication reaches many people through television or radio",
		"prompt": "Use MASS in a sentence about communication.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m5_word_context": {
		"sentence": "the context of communication affects how the message is understood",
		"prompt": "Use CONTEXT in a sentence.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m5_word_audience": {
		"sentence": "the speaker adjusts the speech based on the audience",
		"prompt": "Use AUDIENCE in a sentence.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m5_word_feedback": {
		"sentence": "feedback helps the speaker know if the audience understands the message",
		"prompt": "Use FEEDBACK in a sentence.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m5_word_formal": {
		"sentence": "formal communication is used during school presentations",
		"prompt": "Use FORMAL in a sentence.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m5_word_informal": {
		"sentence": "informal communication happens when i chat with my classmates",
		"prompt": "Use INFORMAL in a sentence.",
		"min_confidence": 0.5,
		"max_attempts": 3
	},
	"oralcom_m5_word_effective": {
		"sentence": "effective communication occurs when the message is clear and understood",
		"prompt": "Use EFFECTIVE in a sentence.",
		"min_confidence": 0.5,
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
	# Oral Communication Module configs
	elif _get_oralcom_config(puzzle_id) != null:
		_start_oralcom_minigame(puzzle_id)
	else:
		push_error("Unknown puzzle: " + puzzle_id)
		return

# Helper to find which oral communication module config contains the puzzle
func _get_oralcom_config(puzzle_id: String) -> Dictionary:
	# Check all module configs
	for module in [oralcom_module1_configs, oralcom_module2_configs, oralcom_module3_configs, oralcom_module4_configs, oralcom_module5_configs]:
		if module.has(puzzle_id):
			return module[puzzle_id]
	return {}

# Start the appropriate minigame type based on puzzle_id suffix
func _start_oralcom_minigame(puzzle_id: String) -> void:
	var config = _get_oralcom_config(puzzle_id)
	if config.is_empty():
		push_error("Could not find oral com config for: " + puzzle_id)
		return

	# Determine minigame type from puzzle_id suffix
	if puzzle_id.ends_with("_pacman"):
		print("DEBUG: Starting Oral Com Pacman minigame...")
		current_minigame = pacman_scene.instantiate()
		get_tree().root.add_child(current_minigame)
		current_minigame.configure_puzzle(config)
		current_minigame.game_finished.connect(_on_minigame_finished.bind(puzzle_id))
	elif puzzle_id.ends_with("_runner"):
		print("DEBUG: Starting Oral Com Runner minigame...")
		current_minigame = runner_scene.instantiate()
		get_tree().root.add_child(current_minigame)
		current_minigame.configure_puzzle(config)
		current_minigame.game_finished.connect(_on_minigame_finished.bind(puzzle_id))
	elif puzzle_id.ends_with("_platformer"):
		print("DEBUG: Starting Oral Com Platformer minigame...")
		current_minigame = platformer_scene.instantiate()
		get_tree().root.add_child(current_minigame)
		current_minigame.configure_puzzle(config)
		current_minigame.game_finished.connect(_on_minigame_finished.bind(puzzle_id))
	elif puzzle_id.ends_with("_maze"):
		print("DEBUG: Starting Oral Com Maze minigame...")
		current_minigame = maze_scene.instantiate()
		get_tree().root.add_child(current_minigame)
		var game_node = current_minigame.get_node("Game")
		game_node.configure_puzzle(config)
		game_node.game_finished.connect(_on_minigame_finished.bind(puzzle_id))
	else:
		push_error("Unknown oral com minigame type for: " + puzzle_id)

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
