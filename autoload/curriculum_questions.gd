extends Node

# Curriculum Question Database for Philippine Senior High School
# Organized by subject > quarter > minigame type

# Quarter mapping based on chapter:
# Chapters 1-2: Q1 (First Quarter)
# Chapter 3: Q2 (Second Quarter)
# Chapter 4: Q3 (Third Quarter)
# Chapter 5: Q4 (Fourth Quarter)

func _chapter_to_quarter(chapter: int) -> String:
	match chapter:
		1, 2:
			return "Q1"
		3:
			return "Q2"
		4:
			return "Q3"
		_:
			return "Q4"

func get_config(minigame_type: String) -> Dictionary:
	var subject = Dialogic.VAR.selected_subject
	var chapter = Dialogic.VAR.current_chapter
	var quarter = _chapter_to_quarter(chapter)

	if not questions.has(subject):
		push_warning("Unknown subject: " + subject)
		return {}

	if not questions[subject].has(quarter):
		push_warning("No questions for quarter: " + quarter)
		return {}

	if not questions[subject][quarter].has(minigame_type):
		push_warning("No " + minigame_type + " for " + subject + "/" + quarter)
		return {}

	return questions[subject][quarter][minigame_type]


# =============================================================================
# QUESTION DATABASE
# =============================================================================

var questions = {
	# =========================================================================
	# MATHEMATICS - Philippine SHS General Mathematics Curriculum
	# Grade 12 - General Mathematics
	# =========================================================================
	"math": {
		# Q1: Functions, Operations, Inverse Functions (Chapters 1-2)
		"Q1": {
			"pacman": {
				"questions": [
					# Function evaluation
					{"question": "If f(x) = 2x + 3, what is f(4)?", "correct": "11", "wrong": ["8", "9", "14"]},
					{"question": "If f(x) = x^2, what is f(3)?", "correct": "9", "wrong": ["6", "3", "12"]},
					{"question": "If f(x) = x - 7, what is f(10)?", "correct": "3", "wrong": ["7", "17", "-3"]},
					{"question": "If g(x) = 3x, what is g(5)?", "correct": "15", "wrong": ["8", "35", "53"]},
					# Function concepts
					{"question": "What test determines if a graph is a function?", "correct": "Vertical line", "wrong": ["Horizontal line", "Diagonal line", "Slope test"]},
					{"question": "The domain is the set of all?", "correct": "Inputs", "wrong": ["Outputs", "Functions", "Ranges"]},
					{"question": "The range is the set of all?", "correct": "Outputs", "wrong": ["Inputs", "Domains", "Variables"]},
					{"question": "f(x) = 1/x is undefined when x = ?", "correct": "0", "wrong": ["1", "-1", "2"]}
				]
			},
			"runner": {
				"questions": [
					# Inverse functions
					{"question": "What is the inverse of f(x) = x + 5?", "correct": "x - 5", "wrong": ["x + 5", "x / 5", "5x"]},
					{"question": "What is the inverse of f(x) = 2x?", "correct": "x / 2", "wrong": ["2x", "x - 2", "x + 2"]},
					{"question": "What is the inverse of f(x) = x - 3?", "correct": "x + 3", "wrong": ["x - 3", "3x", "x / 3"]},
					# Function operations
					{"question": "If f(x)=2x and g(x)=3x, what is (f+g)(x)?", "correct": "5x", "wrong": ["6x", "x", "6x^2"]},
					{"question": "If f(x)=x and g(x)=2, what is (f*g)(x)?", "correct": "2x", "wrong": ["x+2", "x-2", "x/2"]},
					# One-to-one functions
					{"question": "A one-to-one function passes which test?", "correct": "Horizontal line", "wrong": ["Vertical line", "Slope test", "Zero test"]},
					{"question": "The notation for inverse of f is?", "correct": "f^-1", "wrong": ["1/f", "-f", "f*"]},
					{"question": "f(f^-1(x)) always equals?", "correct": "x", "wrong": ["0", "1", "f(x)"]}
				],
				"answers_needed": 5
			},
			"maze": {
				"questions": [
					{"question": "What is the notation for an inverse function?", "correct": "f^-1(x)", "wrong": ["f(x)^-1", "1/f(x)", "-f(x)"]},
					{"question": "Piecewise functions are defined by?", "correct": "Multiple rules", "wrong": ["One rule", "No rules", "Equations"]},
					{"question": "What test checks if an inverse is a function?", "correct": "Horizontal line", "wrong": ["Vertical line", "Diagonal line", "No test"]},
					{"question": "The domain of f^-1 is the ___ of f?", "correct": "Range", "wrong": ["Domain", "Function", "Inverse"]},
					{"question": "A relation where each input has one output is a?", "correct": "Function", "wrong": ["Variable", "Constant", "Set"]}
				]
			},
			"platformer": {
				"questions": [
					{"question": "What is (f * g)(x) if f(x)=2 and g(x)=x?", "correct": "2x", "wrong": ["x+2", "x-2", "x/2"]},
					{"question": "A function maps each input to how many outputs?", "correct": "Exactly one", "wrong": ["Two", "Many", "None"]},
					{"question": "What is 4! (factorial)?", "correct": "24", "wrong": ["4", "16", "8"]},
					{"question": "Evaluate: |−9|", "correct": "9", "wrong": ["-9", "0", "1"]},
					{"question": "If f(x) = x + 1, what is f(0)?", "correct": "1", "wrong": ["0", "-1", "2"]}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": ["A function assigns each ", " to exactly one ", "."],
				"answers": ["input", "output"],
				"choices": ["input", "output", "domain", "range", "variable", "constant", "equation", "value"]
			},
			"math": {
				"questions": [
					{"question": "Evaluate f(x) = 3x - 5 when x = 4", "correct": "7", "wrong": ["12", "2", "17"]},
					{"question": "If f(x) = x² + 1, what is f(3)?", "correct": "10", "wrong": ["9", "8", "6"]},
					{"question": "What is the domain of f(x) = 1/(x-2)?", "correct": "x ≠ 2", "wrong": ["x > 2", "x < 2", "All reals"]},
					{"question": "If f(x) = 2x and g(x) = x+3, find (f∘g)(2)", "correct": "10", "wrong": ["7", "8", "12"]},
					{"question": "What is the inverse of f(x) = 2x + 4?", "correct": "(x-4)/2", "wrong": ["2x-4", "x/2+4", "(x+4)/2"]}
				],
				"time_per_question": 20.0
			}
		},

		# Q2: Exponential & Logarithmic Functions (Chapter 3)
		"Q2": {
			"pacman": {
				"questions": [
					# Logarithm basics
					{"question": "What is log base 10 of 100?", "correct": "2", "wrong": ["10", "100", "1"]},
					{"question": "What is log base 10 of 1000?", "correct": "3", "wrong": ["10", "100", "30"]},
					{"question": "What is log base 2 of 8?", "correct": "3", "wrong": ["2", "4", "8"]},
					{"question": "What is log base 2 of 16?", "correct": "4", "wrong": ["2", "8", "16"]},
					# Exponential basics
					{"question": "2^4 equals?", "correct": "16", "wrong": ["8", "6", "32"]},
					{"question": "3^3 equals?", "correct": "27", "wrong": ["9", "6", "81"]},
					{"question": "5^2 equals?", "correct": "25", "wrong": ["10", "52", "32"]},
					{"question": "Any number raised to 0 equals?", "correct": "1", "wrong": ["0", "Undefined", "Itself"]}
				]
			},
			"runner": {
				"questions": [
					# Log properties
					{"question": "log(ab) equals log(a) + ?", "correct": "log(b)", "wrong": ["log(a)", "ab", "a+b"]},
					{"question": "log(a/b) equals log(a) - ?", "correct": "log(b)", "wrong": ["log(a)", "a-b", "b/a"]},
					{"question": "log(a^n) equals?", "correct": "n log(a)", "wrong": ["a log(n)", "log(n)", "a^n"]},
					{"question": "log(1) equals?", "correct": "0", "wrong": ["1", "10", "undefined"]},
					# Exponential properties
					{"question": "a^m * a^n equals?", "correct": "a^(m+n)", "wrong": ["a^(mn)", "a^(m-n)", "(a*a)^mn"]},
					{"question": "a^m / a^n equals?", "correct": "a^(m-n)", "wrong": ["a^(m+n)", "a^(mn)", "a^(m/n)"]},
					# Applications
					{"question": "Compound interest grows how?", "correct": "Exponentially", "wrong": ["Linearly", "Constantly", "Slowly"]},
					{"question": "What is e approximately equal to?", "correct": "2.718", "wrong": ["3.14", "1.618", "2.5"]}
				],
				"answers_needed": 5
			},
			"maze": {
				"questions": [
					{"question": "Exponential decay has a base between?", "correct": "0 and 1", "wrong": ["1 and 2", "-1 and 0", "2 and 3"]},
					{"question": "Half-life problems use which function?", "correct": "Exponential", "wrong": ["Linear", "Quadratic", "Constant"]},
					{"question": "What is the inverse of y = 10^x?", "correct": "y = log x", "wrong": ["y = 10x", "y = x^10", "y = x/10"]},
					{"question": "The base of natural logarithm ln is?", "correct": "e", "wrong": ["10", "2", "pi"]},
					{"question": "Exponential growth has base greater than?", "correct": "1", "wrong": ["0", "-1", "0.5"]}
				]
			},
			"platformer": {
				"questions": [
					{"question": "5^0 equals?", "correct": "1", "wrong": ["0", "5", "50"]},
					{"question": "10^1 equals?", "correct": "10", "wrong": ["1", "100", "0"]},
					{"question": "2^5 equals?", "correct": "32", "wrong": ["10", "25", "64"]},
					{"question": "4^2 equals?", "correct": "16", "wrong": ["8", "6", "42"]},
					{"question": "log base 10 of 10 equals?", "correct": "1", "wrong": ["0", "10", "100"]}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": ["The inverse of an ", " function is a ", " function."],
				"answers": ["exponential", "logarithmic"],
				"choices": ["exponential", "logarithmic", "linear", "quadratic", "polynomial", "rational", "constant", "inverse"]
			},
			"math": {
				"questions": [
					{"question": "Simplify: 2³ × 2⁴", "correct": "128", "wrong": ["64", "256", "32"]},
					{"question": "What is log₁₀(1000)?", "correct": "3", "wrong": ["2", "4", "10"]},
					{"question": "Solve: 2ˣ = 16", "correct": "4", "wrong": ["3", "5", "8"]},
					{"question": "What is ln(e)?", "correct": "1", "wrong": ["0", "e", "2.718"]},
					{"question": "log(ab) equals?", "correct": "log a + log b", "wrong": ["log a × log b", "log a - log b", "(log a)(log b)"]}
				],
				"time_per_question": 20.0
			}
		},

		# Q3: Trigonometry - Unit Circle, Identities (Chapter 4)
		"Q3": {
			"pacman": {
				"questions": [
					# Basic trig values
					{"question": "sin(90°) equals?", "correct": "1", "wrong": ["0", "-1", "0.5"]},
					{"question": "cos(0°) equals?", "correct": "1", "wrong": ["0", "-1", "0.5"]},
					{"question": "sin(0°) equals?", "correct": "0", "wrong": ["1", "-1", "0.5"]},
					{"question": "cos(90°) equals?", "correct": "0", "wrong": ["1", "-1", "0.5"]},
					{"question": "tan(45°) equals?", "correct": "1", "wrong": ["0", "2", "0.5"]},
					{"question": "sin(30°) equals?", "correct": "0.5", "wrong": ["1", "0", "0.866"]},
					{"question": "cos(60°) equals?", "correct": "0.5", "wrong": ["1", "0", "0.866"]},
					{"question": "sin(180°) equals?", "correct": "0", "wrong": ["1", "-1", "0.5"]}
				]
			},
			"runner": {
				"questions": [
					# Conversions and identities
					{"question": "Pi radians equals how many degrees?", "correct": "180", "wrong": ["360", "90", "270"]},
					{"question": "How many radians in 90 degrees?", "correct": "pi/2", "wrong": ["pi", "2pi", "pi/4"]},
					{"question": "sin^2(x) + cos^2(x) = ?", "correct": "1", "wrong": ["0", "2", "sin(2x)"]},
					{"question": "The period of sin(x) is?", "correct": "2 pi", "wrong": ["pi", "pi/2", "4 pi"]},
					{"question": "What is the amplitude of y = 3sin(x)?", "correct": "3", "wrong": ["1", "6", "1/3"]},
					# Reciprocal functions
					{"question": "csc is the reciprocal of?", "correct": "sin", "wrong": ["cos", "tan", "sec"]},
					{"question": "sec is the reciprocal of?", "correct": "cos", "wrong": ["sin", "tan", "cot"]},
					{"question": "cot is the reciprocal of?", "correct": "tan", "wrong": ["sin", "cos", "sec"]}
				],
				"answers_needed": 5
			},
			"maze": {
				"questions": [
					{"question": "In Quadrant II, sin is positive and cos is?", "correct": "Negative", "wrong": ["Positive", "Zero", "Undefined"]},
					{"question": "In Quadrant III, both sin and cos are?", "correct": "Negative", "wrong": ["Positive", "Zero", "One positive"]},
					{"question": "The unit circle has radius?", "correct": "1", "wrong": ["2", "pi", "0"]},
					{"question": "tan = sin divided by?", "correct": "cos", "wrong": ["tan", "sin", "sec"]},
					{"question": "cot = cos divided by?", "correct": "sin", "wrong": ["tan", "cos", "sec"]}
				]
			},
			"platformer": {
				"questions": [
					{"question": "How many degrees in a full circle?", "correct": "360", "wrong": ["180", "90", "270"]},
					{"question": "How many radians in a full circle?", "correct": "2 pi", "wrong": ["pi", "4 pi", "pi/2"]},
					{"question": "cos(180°) equals?", "correct": "-1", "wrong": ["1", "0", "0.5"]},
					{"question": "What angle has sin = cos?", "correct": "45 degrees", "wrong": ["30 degrees", "60 degrees", "90 degrees"]},
					{"question": "sin(270°) equals?", "correct": "-1", "wrong": ["1", "0", "0.5"]}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": ["The ", " function relates an angle to the ratio of opposite over ", "."],
				"answers": ["sine", "hypotenuse"],
				"choices": ["sine", "cosine", "tangent", "hypotenuse", "adjacent", "opposite", "angle", "ratio"]
			},
			"math": {
				"questions": [
					{"question": "What is sin(30°)?", "correct": "1/2", "wrong": ["√3/2", "√2/2", "1"]},
					{"question": "What is cos(60°)?", "correct": "1/2", "wrong": ["√3/2", "√2/2", "0"]},
					{"question": "What is tan(45°)?", "correct": "1", "wrong": ["0", "√2", "√3"]},
					{"question": "sin²θ + cos²θ equals?", "correct": "1", "wrong": ["0", "2", "sin 2θ"]},
					{"question": "What is the period of sin(x)?", "correct": "2π", "wrong": ["π", "π/2", "4π"]}
				],
				"time_per_question": 20.0
			}
		},

		# Q4: Statistics and Probability (Chapter 5)
		"Q4": {
			"pacman": {
				"questions": [
					# Central tendency
					{"question": "The mean of 2, 4, 6 is?", "correct": "4", "wrong": ["2", "6", "12"]},
					{"question": "The mean of 10, 20, 30 is?", "correct": "20", "wrong": ["10", "30", "60"]},
					{"question": "The median of 1, 3, 5 is?", "correct": "3", "wrong": ["1", "5", "9"]},
					{"question": "The mode of 2, 2, 3, 4 is?", "correct": "2", "wrong": ["3", "4", "2.75"]},
					# Probability basics
					{"question": "Probability ranges from?", "correct": "0 to 1", "wrong": ["0 to 100", "-1 to 1", "1 to 10"]},
					{"question": "P(heads) for fair coin is?", "correct": "0.5", "wrong": ["0.25", "1", "0"]},
					{"question": "Probability of impossible event?", "correct": "0", "wrong": ["1", "0.5", "-1"]},
					{"question": "Probability of certain event?", "correct": "1", "wrong": ["0", "0.5", "100"]}
				]
			},
			"runner": {
				"questions": [
					# Variability measures
					{"question": "Standard deviation measures?", "correct": "Spread", "wrong": ["Center", "Mode", "Median"]},
					{"question": "Variance is standard deviation?", "correct": "Squared", "wrong": ["Halved", "Doubled", "Cubed"]},
					{"question": "Range = Maximum minus?", "correct": "Minimum", "wrong": ["Mean", "Mode", "Median"]},
					# Probability rules
					{"question": "P(A and B) for independent events = ?", "correct": "P(A) x P(B)", "wrong": ["P(A) + P(B)", "P(A) - P(B)", "P(A)/P(B)"]},
					{"question": "P(A or B) for mutually exclusive = ?", "correct": "P(A) + P(B)", "wrong": ["P(A) x P(B)", "P(A) - P(B)", "P(A)/P(B)"]},
					{"question": "P(not A) = 1 minus?", "correct": "P(A)", "wrong": ["P(B)", "0", "1"]},
					{"question": "The sum of all probabilities equals?", "correct": "1", "wrong": ["0", "100", "0.5"]},
					# Distribution
					{"question": "The normal curve is shaped like?", "correct": "Bell", "wrong": ["Square", "Triangle", "Line"]}
				],
				"answers_needed": 5
			},
			"maze": {
				"questions": [
					{"question": "In a normal distribution, mean = median = ?", "correct": "Mode", "wrong": ["Range", "Variance", "Sum"]},
					{"question": "nCr is used for?", "correct": "Combinations", "wrong": ["Permutations", "Probability", "Mean"]},
					{"question": "nPr is used for?", "correct": "Permutations", "wrong": ["Combinations", "Variance", "Mode"]},
					{"question": "5! (factorial) equals?", "correct": "120", "wrong": ["25", "20", "60"]},
					{"question": "4! (factorial) equals?", "correct": "24", "wrong": ["4", "16", "8"]}
				]
			},
			"platformer": {
				"questions": [
					{"question": "Mean is also called?", "correct": "Average", "wrong": ["Middle", "Most common", "Range"]},
					{"question": "Median is the ___ value?", "correct": "Middle", "wrong": ["First", "Last", "Largest"]},
					{"question": "Mode is the most ___ value?", "correct": "Frequent", "wrong": ["Average", "Middle", "Large"]},
					{"question": "3! equals?", "correct": "6", "wrong": ["3", "9", "27"]},
					{"question": "Rolling a 6 on fair die: P = ?", "correct": "1/6", "wrong": ["1/2", "1/3", "6"]}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": ["The ", " is the sum of values divided by the ", " of values."],
				"answers": ["mean", "count"],
				"choices": ["mean", "median", "mode", "count", "range", "sum", "total", "number"]
			},
			"math": {
				"questions": [
					{"question": "The mean of 2, 4, 6, 8 is?", "correct": "5", "wrong": ["4", "6", "20"]},
					{"question": "The median of 1, 3, 5, 7, 9 is?", "correct": "5", "wrong": ["3", "7", "25"]},
					{"question": "P(A) + P(not A) equals?", "correct": "1", "wrong": ["0", "2", "P(A)²"]},
					{"question": "Probability of rolling 6 on a die?", "correct": "1/6", "wrong": ["1/2", "1/3", "6"]},
					{"question": "Standard deviation measures?", "correct": "Spread", "wrong": ["Center", "Mode", "Range"]}
				],
				"time_per_question": 20.0
			}
		}
	},

	# =========================================================================
	# SCIENCE - Philippine SHS Earth Science & Physical Science Curriculum
	# =========================================================================
	"science": {
		# Q1: Earth's Structure, Plate Tectonics
		"Q1": {
			"pacman": {
				"questions": [
					{
						"question": "The Earth's outermost layer is the?",
						"correct": "Crust",
						"wrong": ["Mantle", "Core", "Magma"]
					},
					{
						"question": "What causes earthquakes?",
						"correct": "Plate movement",
						"wrong": ["Rain", "Wind", "Gravity"]
					},
					{
						"question": "The center of Earth is the?",
						"correct": "Core",
						"wrong": ["Crust", "Mantle", "Surface"]
					},
					{
						"question": "Pangaea was a?",
						"correct": "Supercontinent",
						"wrong": ["Ocean", "Mountain", "Volcano"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "Tectonic plates float on the?",
						"correct": "Asthenosphere",
						"wrong": ["Crust", "Core", "Ocean"]
					},
					{
						"question": "The Ring of Fire is in which ocean?",
						"correct": "Pacific",
						"wrong": ["Atlantic", "Indian", "Arctic"]
					},
					{
						"question": "What instrument measures earthquakes?",
						"correct": "Seismograph",
						"wrong": ["Thermometer", "Barometer", "Compass"]
					},
					{
						"question": "Magma that reaches surface becomes?",
						"correct": "Lava",
						"wrong": ["Rock", "Water", "Gas"]
					},
					{
						"question": "Continental drift was proposed by?",
						"correct": "Wegener",
						"wrong": ["Newton", "Einstein", "Darwin"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "The Richter scale measures earthquake?",
						"correct": "Magnitude",
						"wrong": ["Location", "Duration", "Depth"]
					},
					{
						"question": "Oceanic crust is mostly?",
						"correct": "Basalt",
						"wrong": ["Granite", "Sandstone", "Marble"]
					},
					{
						"question": "Convergent boundaries create?",
						"correct": "Mountains",
						"wrong": ["Valleys", "Rivers", "Plains"]
					},
					{
						"question": "Divergent boundaries create new?",
						"correct": "Crust",
						"wrong": ["Mountains", "Trenches", "Islands"]
					},
					{
						"question": "The lithosphere includes crust and upper?",
						"correct": "Mantle",
						"wrong": ["Core", "Ocean", "Atmosphere"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "How many major tectonic plates exist?",
						"correct": "7",
						"wrong": ["3", "10", "20"]
					},
					{
						"question": "The Philippines is on which plate?",
						"correct": "Philippine",
						"wrong": ["Pacific", "Eurasian", "Australian"]
					},
					{
						"question": "P-waves are also called?",
						"correct": "Primary",
						"wrong": ["Secondary", "Surface", "Deep"]
					},
					{
						"question": "S-waves cannot travel through?",
						"correct": "Liquids",
						"wrong": ["Solids", "Air", "Rock"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"The theory of ", " explains how continents move across Earth's ", "."
				],
				"answers": ["plate tectonics", "surface"],
				"choices": [
					"plate tectonics", "continental drift", "surface", "core",
					"evolution", "gravity", "mantle", "crust"
				]
			}
		},

		# Q2: Weather, Climate, Natural Hazards
		"Q2": {
			"pacman": {
				"questions": [
					{
						"question": "What layer of atmosphere has weather?",
						"correct": "Troposphere",
						"wrong": ["Stratosphere", "Mesosphere", "Thermosphere"]
					},
					{
						"question": "Typhoons form over warm?",
						"correct": "Ocean",
						"wrong": ["Land", "Mountains", "Desert"]
					},
					{
						"question": "Climate is weather over?",
						"correct": "Long time",
						"wrong": ["One day", "One week", "One hour"]
					},
					{
						"question": "The ozone layer is in the?",
						"correct": "Stratosphere",
						"wrong": ["Troposphere", "Mesosphere", "Core"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "El Nino causes what in Philippines?",
						"correct": "Drought",
						"wrong": ["Floods", "Snow", "Earthquakes"]
					},
					{
						"question": "La Nina causes what in Philippines?",
						"correct": "More rain",
						"wrong": ["Drought", "Heat wave", "Tsunami"]
					},
					{
						"question": "Greenhouse gases trap?",
						"correct": "Heat",
						"wrong": ["Water", "Light", "Sound"]
					},
					{
						"question": "What causes a tsunami?",
						"correct": "Underwater earthquake",
						"wrong": ["Strong wind", "Rain", "High tide"]
					},
					{
						"question": "PAGASA monitors weather in?",
						"correct": "Philippines",
						"wrong": ["Japan", "USA", "China"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "Global warming is caused by?",
						"correct": "Greenhouse gases",
						"wrong": ["Ozone", "Oxygen", "Nitrogen"]
					},
					{
						"question": "Carbon dioxide is a greenhouse?",
						"correct": "Gas",
						"wrong": ["Liquid", "Solid", "Plasma"]
					},
					{
						"question": "Typhoon signal 4 means winds over?",
						"correct": "185 kph",
						"wrong": ["100 kph", "61 kph", "250 kph"]
					},
					{
						"question": "Landslides are triggered by?",
						"correct": "Heavy rain",
						"wrong": ["Drought", "Sunshine", "Cold"]
					},
					{
						"question": "Flash floods occur in?",
						"correct": "Minutes",
						"wrong": ["Days", "Weeks", "Months"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "Humidity measures water vapor in?",
						"correct": "Air",
						"wrong": ["Soil", "Ocean", "Rock"]
					},
					{
						"question": "Rain gauge measures?",
						"correct": "Rainfall",
						"wrong": ["Wind", "Temperature", "Pressure"]
					},
					{
						"question": "Anemometer measures?",
						"correct": "Wind speed",
						"wrong": ["Rainfall", "Temperature", "Humidity"]
					},
					{
						"question": "Barometer measures?",
						"correct": "Air pressure",
						"wrong": ["Wind", "Rain", "Humidity"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"Climate ", " is the long-term shift in global ", " patterns."
				],
				"answers": ["change", "weather"],
				"choices": [
					"change", "weather", "temperature", "pressure",
					"shift", "pattern", "warming", "cooling"
				]
			}
		},

		# Q3: Biology, Genetics
		"Q3": {
			"pacman": {
				"questions": [
					{
						"question": "The basic unit of life is the?",
						"correct": "Cell",
						"wrong": ["Atom", "Organ", "Tissue"]
					},
					{
						"question": "DNA stands for deoxyribonucleic?",
						"correct": "Acid",
						"wrong": ["Base", "Sugar", "Protein"]
					},
					{
						"question": "Mitochondria produce?",
						"correct": "Energy",
						"wrong": ["Protein", "DNA", "Water"]
					},
					{
						"question": "Photosynthesis occurs in?",
						"correct": "Chloroplasts",
						"wrong": ["Mitochondria", "Nucleus", "Ribosome"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "Genes are made of?",
						"correct": "DNA",
						"wrong": ["Protein", "Carbs", "Fat"]
					},
					{
						"question": "How many chromosomes do humans have?",
						"correct": "46",
						"wrong": ["23", "48", "92"]
					},
					{
						"question": "Dominant traits need how many alleles?",
						"correct": "One",
						"wrong": ["Two", "Three", "None"]
					},
					{
						"question": "Recessive traits need how many alleles?",
						"correct": "Two",
						"wrong": ["One", "Three", "None"]
					},
					{
						"question": "Gregor Mendel studied?",
						"correct": "Pea plants",
						"wrong": ["Fruit flies", "Mice", "Bacteria"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "RNA differs from DNA by having?",
						"correct": "Uracil",
						"wrong": ["Thymine", "Adenine", "Cytosine"]
					},
					{
						"question": "Mitosis produces how many cells?",
						"correct": "2",
						"wrong": ["4", "1", "8"]
					},
					{
						"question": "Meiosis produces how many cells?",
						"correct": "4",
						"wrong": ["2", "1", "8"]
					},
					{
						"question": "The nucleus contains?",
						"correct": "DNA",
						"wrong": ["ATP", "Enzymes", "Water"]
					},
					{
						"question": "Proteins are made by?",
						"correct": "Ribosomes",
						"wrong": ["Nucleus", "Mitochondria", "Vacuole"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "A = T and G = C is called base?",
						"correct": "Pairing",
						"wrong": ["Matching", "Coding", "Binding"]
					},
					{
						"question": "XX chromosomes indicate?",
						"correct": "Female",
						"wrong": ["Male", "Unknown", "Hybrid"]
					},
					{
						"question": "XY chromosomes indicate?",
						"correct": "Male",
						"wrong": ["Female", "Unknown", "Hybrid"]
					},
					{
						"question": "Genotype refers to?",
						"correct": "Genes",
						"wrong": ["Appearance", "Behavior", "Environment"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"", " is the physical expression of genes, while genotype is the ", " makeup."
				],
				"answers": ["Phenotype", "genetic"],
				"choices": [
					"Phenotype", "Genotype", "genetic", "physical",
					"DNA", "RNA", "protein", "trait"
				]
			}
		},

		# Q4: Chemistry, Atomic Structure
		"Q4": {
			"pacman": {
				"questions": [
					{
						"question": "The center of an atom is the?",
						"correct": "Nucleus",
						"wrong": ["Electron", "Shell", "Proton"]
					},
					{
						"question": "Electrons have what charge?",
						"correct": "Negative",
						"wrong": ["Positive", "Neutral", "None"]
					},
					{
						"question": "Protons have what charge?",
						"correct": "Positive",
						"wrong": ["Negative", "Neutral", "None"]
					},
					{
						"question": "H2O is the formula for?",
						"correct": "Water",
						"wrong": ["Salt", "Sugar", "Oxygen"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "Atomic number equals number of?",
						"correct": "Protons",
						"wrong": ["Neutrons", "Electrons", "Shells"]
					},
					{
						"question": "Ionic bonds transfer?",
						"correct": "Electrons",
						"wrong": ["Protons", "Neutrons", "Atoms"]
					},
					{
						"question": "Covalent bonds share?",
						"correct": "Electrons",
						"wrong": ["Protons", "Neutrons", "Atoms"]
					},
					{
						"question": "NaCl is common?",
						"correct": "Salt",
						"wrong": ["Sugar", "Water", "Acid"]
					},
					{
						"question": "pH 7 is?",
						"correct": "Neutral",
						"wrong": ["Acidic", "Basic", "Salty"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "Noble gases have a full outer?",
						"correct": "Shell",
						"wrong": ["Nucleus", "Proton", "Neutron"]
					},
					{
						"question": "Metals are good conductors of?",
						"correct": "Electricity",
						"wrong": ["Sound", "Light", "Heat only"]
					},
					{
						"question": "Acids have pH less than?",
						"correct": "7",
						"wrong": ["14", "0", "10"]
					},
					{
						"question": "Bases have pH greater than?",
						"correct": "7",
						"wrong": ["0", "14", "3"]
					},
					{
						"question": "The periodic table organizes?",
						"correct": "Elements",
						"wrong": ["Compounds", "Molecules", "Mixtures"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "CO2 is carbon?",
						"correct": "Dioxide",
						"wrong": ["Monoxide", "Trioxide", "Oxide"]
					},
					{
						"question": "Neutrons have what charge?",
						"correct": "None",
						"wrong": ["Positive", "Negative", "Both"]
					},
					{
						"question": "Mass number = protons + ?",
						"correct": "Neutrons",
						"wrong": ["Electrons", "Atoms", "Shells"]
					},
					{
						"question": "O2 is?",
						"correct": "Oxygen",
						"wrong": ["Ozone", "Water", "Carbon"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"An atom is electrically ", " because protons equal ", "."
				],
				"answers": ["neutral", "electrons"],
				"choices": [
					"neutral", "positive", "negative", "electrons",
					"protons", "neutrons", "charged", "ions"
				]
			}
		}
	},

	# =========================================================================
	# ENGLISH - Philippine SHS Oral Communication Curriculum
	# =========================================================================
	"english": {
		# Q1: Elements of Communication, Communication Models
		"Q1": {
			"pacman": {
				"questions": [
					{
						"question": "Who starts the communication process?",
						"correct": "Sender",
						"wrong": ["Receiver", "Channel", "Message"]
					},
					{
						"question": "The information being shared is the?",
						"correct": "Message",
						"wrong": ["Channel", "Feedback", "Noise"]
					},
					{
						"question": "The response from receiver is called?",
						"correct": "Feedback",
						"wrong": ["Message", "Channel", "Noise"]
					},
					{
						"question": "Anything that interferes is called?",
						"correct": "Noise",
						"wrong": ["Message", "Feedback", "Channel"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "Converting ideas to words is?",
						"correct": "Encoding",
						"wrong": ["Decoding", "Sending", "Receiving"]
					},
					{
						"question": "Interpreting the message is?",
						"correct": "Decoding",
						"wrong": ["Encoding", "Sending", "Feedback"]
					},
					{
						"question": "The medium of communication is?",
						"correct": "Channel",
						"wrong": ["Message", "Noise", "Feedback"]
					},
					{
						"question": "Face-to-face uses which channel?",
						"correct": "Verbal",
						"wrong": ["Written", "Digital", "None"]
					},
					{
						"question": "Body language is what communication?",
						"correct": "Nonverbal",
						"wrong": ["Verbal", "Written", "Digital"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "Linear model is?",
						"correct": "One-way",
						"wrong": ["Two-way", "Circular", "Complex"]
					},
					{
						"question": "Interactive model includes?",
						"correct": "Feedback",
						"wrong": ["One sender", "No receiver", "Silence"]
					},
					{
						"question": "Transactional model is?",
						"correct": "Simultaneous",
						"wrong": ["One-way", "Delayed", "Written"]
					},
					{
						"question": "Aristotle's model focuses on?",
						"correct": "Public speaking",
						"wrong": ["Writing", "Texting", "Listening"]
					},
					{
						"question": "Shannon-Weaver model includes?",
						"correct": "Noise",
						"wrong": ["Only sender", "No receiver", "No message"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "Communication within yourself is?",
						"correct": "Intrapersonal",
						"wrong": ["Interpersonal", "Mass", "Public"]
					},
					{
						"question": "Communication between people is?",
						"correct": "Interpersonal",
						"wrong": ["Intrapersonal", "Mass", "Personal"]
					},
					{
						"question": "TV and radio are what communication?",
						"correct": "Mass",
						"wrong": ["Interpersonal", "Intrapersonal", "Small"]
					},
					{
						"question": "Speeches use what communication?",
						"correct": "Public",
						"wrong": ["Intrapersonal", "Mass", "Private"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"The ", " sends the message while the ", " interprets it."
				],
				"answers": ["sender", "receiver"],
				"choices": [
					"sender", "receiver", "message", "channel",
					"feedback", "noise", "encoder", "decoder"
				]
			}
		},

		# Q2: Communication Strategies, Avoiding Breakdown
		"Q2": {
			"pacman": {
				"questions": [
					{
						"question": "Failed communication is called?",
						"correct": "Breakdown",
						"wrong": ["Success", "Feedback", "Encoding"]
					},
					{
						"question": "Asking questions for understanding is?",
						"correct": "Clarification",
						"wrong": ["Noise", "Silence", "Encoding"]
					},
					{
						"question": "Clear expression of ideas is?",
						"correct": "Clarity",
						"wrong": ["Noise", "Silence", "Breakdown"]
					},
					{
						"question": "Showing respect in communication is?",
						"correct": "Courtesy",
						"wrong": ["Noise", "Breakdown", "Clarity"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "Being brief without losing meaning is?",
						"correct": "Conciseness",
						"wrong": ["Clarity", "Courtesy", "Noise"]
					},
					{
						"question": "Providing all needed info is?",
						"correct": "Completeness",
						"wrong": ["Conciseness", "Clarity", "Noise"]
					},
					{
						"question": "Using proper grammar is?",
						"correct": "Correctness",
						"wrong": ["Clarity", "Courtesy", "Noise"]
					},
					{
						"question": "Adjusting to your audience is?",
						"correct": "Adaptation",
						"wrong": ["Noise", "Breakdown", "Encoding"]
					},
					{
						"question": "Active listening requires?",
						"correct": "Attention",
						"wrong": ["Talking", "Writing", "Sleeping"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "Physical noise is?",
						"correct": "External sounds",
						"wrong": ["Emotions", "Prejudice", "Language"]
					},
					{
						"question": "Psychological noise is?",
						"correct": "Mental distraction",
						"wrong": ["Loud music", "Traffic", "Typing"]
					},
					{
						"question": "Semantic noise involves?",
						"correct": "Word meaning",
						"wrong": ["Loud sounds", "Emotions", "Distance"]
					},
					{
						"question": "Eye contact shows?",
						"correct": "Interest",
						"wrong": ["Boredom", "Anger", "Sadness"]
					},
					{
						"question": "Paraphrasing helps confirm?",
						"correct": "Understanding",
						"wrong": ["Confusion", "Noise", "Breakdown"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "Repeating back what you heard is?",
						"correct": "Paraphrasing",
						"wrong": ["Ignoring", "Shouting", "Writing"]
					},
					{
						"question": "Nodding shows you are?",
						"correct": "Listening",
						"wrong": ["Sleeping", "Ignoring", "Confused"]
					},
					{
						"question": "Open-ended questions encourage?",
						"correct": "Discussion",
						"wrong": ["Silence", "Yes/No", "Confusion"]
					},
					{
						"question": "Closed questions get?",
						"correct": "Short answers",
						"wrong": ["Long answers", "Stories", "Essays"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"Communication ", " occurs when the message is not ", " by the receiver."
				],
				"answers": ["breakdown", "understood"],
				"choices": [
					"breakdown", "success", "understood", "received",
					"sent", "encoded", "decoded", "feedback"
				]
			}
		},

		# Q3: Types of Speech Context, Speech Acts
		"Q3": {
			"pacman": {
				"questions": [
					{
						"question": "Formal speaking style is used in?",
						"correct": "Ceremonies",
						"wrong": ["Casual talks", "Texting", "Jokes"]
					},
					{
						"question": "Casual style is used with?",
						"correct": "Friends",
						"wrong": ["Bosses", "Judges", "Presidents"]
					},
					{
						"question": "A promise is what speech act?",
						"correct": "Commissive",
						"wrong": ["Directive", "Expressive", "Declarative"]
					},
					{
						"question": "A command is what speech act?",
						"correct": "Directive",
						"wrong": ["Commissive", "Expressive", "Assertive"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "Expressing emotions is?",
						"correct": "Expressive",
						"wrong": ["Directive", "Commissive", "Assertive"]
					},
					{
						"question": "Stating facts is?",
						"correct": "Assertive",
						"wrong": ["Directive", "Expressive", "Commissive"]
					},
					{
						"question": "Formal register uses?",
						"correct": "Complete sentences",
						"wrong": ["Slang", "Emojis", "Abbreviations"]
					},
					{
						"question": "Consultative style is used in?",
						"correct": "Professional talks",
						"wrong": ["With strangers", "At home", "Parties"]
					},
					{
						"question": "Intimate style is used with?",
						"correct": "Close family",
						"wrong": ["Strangers", "Teachers", "Police"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "Frozen style is?",
						"correct": "Unchanging",
						"wrong": ["Flexible", "Casual", "Slang"]
					},
					{
						"question": "The Pledge of Allegiance uses?",
						"correct": "Frozen style",
						"wrong": ["Casual", "Intimate", "Consultative"]
					},
					{
						"question": "Locutionary act is?",
						"correct": "Saying words",
						"wrong": ["Meaning", "Effect", "Context"]
					},
					{
						"question": "Illocutionary act is?",
						"correct": "Intended meaning",
						"wrong": ["Just words", "Effect", "Sound"]
					},
					{
						"question": "Perlocutionary act is?",
						"correct": "Effect on listener",
						"wrong": ["Words only", "Intent", "Grammar"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "I now pronounce you married is?",
						"correct": "Declarative",
						"wrong": ["Assertive", "Directive", "Expressive"]
					},
					{
						"question": "Thank you is?",
						"correct": "Expressive",
						"wrong": ["Directive", "Commissive", "Assertive"]
					},
					{
						"question": "I promise to help is?",
						"correct": "Commissive",
						"wrong": ["Directive", "Expressive", "Declarative"]
					},
					{
						"question": "Please close the door is?",
						"correct": "Directive",
						"wrong": ["Commissive", "Assertive", "Expressive"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"Speech ", " are the functions of language used to perform ", " actions."
				],
				"answers": ["acts", "communicative"],
				"choices": [
					"acts", "styles", "communicative", "verbal",
					"written", "nonverbal", "functions", "meanings"
				]
			}
		},

		# Q4: Presentation Skills, Argumentation
		"Q4": {
			"pacman": {
				"questions": [
					{
						"question": "Good posture shows?",
						"correct": "Confidence",
						"wrong": ["Fear", "Boredom", "Anger"]
					},
					{
						"question": "Speaking too fast causes?",
						"correct": "Confusion",
						"wrong": ["Clarity", "Interest", "Understanding"]
					},
					{
						"question": "Visual aids help?",
						"correct": "Understanding",
						"wrong": ["Confusion", "Boredom", "Sleep"]
					},
					{
						"question": "A claim in argument is?",
						"correct": "Main point",
						"wrong": ["Evidence", "Counter", "Conclusion"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "Evidence supports the?",
						"correct": "Claim",
						"wrong": ["Counterclaim", "Conclusion", "Title"]
					},
					{
						"question": "A counterclaim is?",
						"correct": "Opposing view",
						"wrong": ["Your claim", "Evidence", "Conclusion"]
					},
					{
						"question": "Rebuttal responds to?",
						"correct": "Counterclaim",
						"wrong": ["Your claim", "Evidence", "Title"]
					},
					{
						"question": "Ethos appeals to?",
						"correct": "Credibility",
						"wrong": ["Emotion", "Logic", "Fear"]
					},
					{
						"question": "Pathos appeals to?",
						"correct": "Emotion",
						"wrong": ["Logic", "Credibility", "Facts"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "Logos appeals to?",
						"correct": "Logic",
						"wrong": ["Emotion", "Credibility", "Fear"]
					},
					{
						"question": "Ad hominem attacks the?",
						"correct": "Person",
						"wrong": ["Argument", "Evidence", "Logic"]
					},
					{
						"question": "A straw man misrepresents the?",
						"correct": "Opponent's view",
						"wrong": ["Your view", "Evidence", "Facts"]
					},
					{
						"question": "Hasty generalization uses?",
						"correct": "Few examples",
						"wrong": ["Many examples", "No examples", "Facts"]
					},
					{
						"question": "Appeal to authority uses?",
						"correct": "Expert opinion",
						"wrong": ["Emotion", "Logic", "Fear"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "Introduction should grab?",
						"correct": "Attention",
						"wrong": ["Sleep", "Boredom", "Confusion"]
					},
					{
						"question": "Conclusion should be?",
						"correct": "Memorable",
						"wrong": ["Boring", "Rushed", "Confusing"]
					},
					{
						"question": "Transitions connect?",
						"correct": "Ideas",
						"wrong": ["Nothing", "Slides", "Papers"]
					},
					{
						"question": "Vocal variety prevents?",
						"correct": "Boredom",
						"wrong": ["Interest", "Understanding", "Clarity"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"A strong ", " is supported by ", " and logical reasoning."
				],
				"answers": ["argument", "evidence"],
				"choices": [
					"argument", "opinion", "evidence", "emotion",
					"claim", "story", "fact", "guess"
				]
			}
		}
	}
}

# =============================================================================
# REVIEW CONTENT DATABASE
# Educational content shown when players fail minigames repeatedly
# =============================================================================

var review_content = {
	"math": {
		"Q1": {
			"title": "Functions & Relations",
			"explanation": "A function assigns each input exactly one output. Understanding domain (inputs) and range (outputs) is crucial for working with functions.",
			"key_concepts": [
				"Domain: All possible input values",
				"Range: All possible output values",
				"Vertical Line Test: A graph is a function if no vertical line crosses it twice"
			],
			"example": "For f(x) = 2x + 3, if x = 4: f(4) = 2(4) + 3 = 11",
			"tip": "To find the domain, ask 'what x values are allowed?' To find range, ask 'what y values can result?'"
		},
		"Q2": {
			"title": "Exponentials & Logarithms",
			"explanation": "Exponential functions grow rapidly. Logarithms are the inverse - they tell you 'what power do I need?'",
			"key_concepts": [
				"Exponential: y = a^x (a is base, x is exponent)",
				"Logarithm: log_a(y) = x means a^x = y",
				"Properties: log(ab) = log(a) + log(b)"
			],
			"example": "log₂(8) = 3 because 2³ = 8",
			"tip": "When solving exponential equations, take the log of both sides to bring the exponent down."
		},
		"Q3": {
			"title": "Trigonometry",
			"explanation": "Trigonometry studies relationships between angles and sides of triangles. SOH-CAH-TOA is your friend!",
			"key_concepts": [
				"SOH: sin = opposite/hypotenuse",
				"CAH: cos = adjacent/hypotenuse",
				"TOA: tan = opposite/adjacent"
			],
			"example": "In a right triangle with angle 30°, opposite side 5, and hypotenuse 10: sin(30°) = 5/10 = 0.5",
			"tip": "Draw a diagram! Most trig problems become easier when you can see the triangle."
		},
		"Q4": {
			"title": "Statistics & Probability",
			"explanation": "Statistics helps us understand data. Probability tells us how likely events are to occur.",
			"key_concepts": [
				"Mean: Average (sum of all values / count)",
				"Median: Middle value when sorted",
				"Mode: Most frequent value",
				"Probability: (favorable outcomes) / (total outcomes)"
			],
			"example": "Rolling a die: P(rolling 6) = 1/6 ≈ 16.7%",
			"tip": "For probability, first count all possible outcomes, then count how many are favorable."
		}
	},
	"science": {
		"Q1": {
			"title": "Earth & Space Science",
			"explanation": "Earth is made of layers (crust, mantle, core) and constantly changes through geological processes.",
			"key_concepts": [
				"Plate tectonics: Earth's crust is divided into moving plates",
				"Rock cycle: Rocks transform between igneous, sedimentary, and metamorphic",
				"Weathering & erosion: Breaking down and transporting materials"
			],
			"example": "Earthquakes occur where tectonic plates meet and release built-up energy.",
			"tip": "Think of Earth as dynamic, not static - everything is slowly moving and changing."
		},
		"Q2": {
			"title": "Life Science & Biology",
			"explanation": "All living things are made of cells and share common characteristics like growth, reproduction, and response to environment.",
			"key_concepts": [
				"Cell theory: All life is made of cells",
				"Photosynthesis: Plants convert light → sugar + oxygen",
				"Cellular respiration: Cells convert sugar → energy + CO₂"
			],
			"example": "A plant cell uses chloroplasts for photosynthesis, while animal cells don't have chloroplasts.",
			"tip": "Remember: plants do BOTH photosynthesis AND cellular respiration."
		},
		"Q3": {
			"title": "Chemistry Basics",
			"explanation": "Matter is made of atoms, which combine to form molecules. Chemical reactions rearrange atoms.",
			"key_concepts": [
				"Atoms: Smallest unit of an element (protons, neutrons, electrons)",
				"Molecules: Atoms bonded together (H₂O = 2 hydrogen + 1 oxygen)",
				"Chemical reactions: Bonds break and form, creating new substances"
			],
			"example": "Water (H₂O) forms when hydrogen gas (H₂) reacts with oxygen gas (O₂).",
			"tip": "In chemical equations, atoms are never created or destroyed - they just rearrange."
		},
		"Q4": {
			"title": "Physics Fundamentals",
			"explanation": "Physics studies motion, forces, and energy. Newton's laws explain how objects move.",
			"key_concepts": [
				"Newton's 1st Law: Objects stay at rest or in motion unless acted on by force",
				"Newton's 2nd Law: F = ma (force = mass × acceleration)",
				"Newton's 3rd Law: For every action, there's an equal opposite reaction"
			],
			"example": "Pushing a cart: more force = more acceleration. Heavier cart = less acceleration for same force.",
			"tip": "Forces always come in pairs. If you push on a wall, the wall pushes back on you."
		}
	},
	"english": {
		"Q1": {
			"title": "Communication & Language",
			"explanation": "Effective communication requires understanding your audience, purpose, and context.",
			"key_concepts": [
				"Sender → Message → Receiver (communication model)",
				"Context matters: formal vs informal, written vs spoken",
				"Active listening: Pay attention, ask questions, provide feedback"
			],
			"example": "Texting a friend: informal, brief. Writing a job application: formal, detailed.",
			"tip": "Before communicating, ask: Who is my audience? What's my purpose? What tone is appropriate?"
		},
		"Q2": {
			"title": "Reading Comprehension",
			"explanation": "Strong readers make connections, ask questions, and identify main ideas.",
			"key_concepts": [
				"Main idea: The central point of a text",
				"Supporting details: Evidence and examples that explain the main idea",
				"Inference: Reading between the lines to understand implied meaning"
			],
			"example": "If a character slams a door and doesn't respond to questions, you can infer they're angry.",
			"tip": "After each paragraph, pause and ask: 'What's the main point here?' Summarize in your own words."
		},
		"Q3": {
			"title": "Writing & Composition",
			"explanation": "Good writing is clear, organized, and purposeful. It has a beginning, middle, and end.",
			"key_concepts": [
				"Thesis statement: Your main argument or point",
				"Topic sentences: Introduce the main idea of each paragraph",
				"Transitions: Connect ideas smoothly (however, therefore, in addition)"
			],
			"example": "Essay structure: Introduction (thesis) → Body paragraphs (evidence) → Conclusion (summary).",
			"tip": "Outline before writing! Plan your main points and supporting details first."
		},
		"Q4": {
			"title": "Literary Analysis",
			"explanation": "Literature uses literary devices (metaphor, symbolism, theme) to convey deeper meaning.",
			"key_concepts": [
				"Theme: The central idea or message (love, courage, justice)",
				"Symbolism: Objects representing abstract ideas (dove = peace)",
				"Point of view: Who tells the story (1st person 'I', 3rd person 'he/she')"
			],
			"example": "In 'The Little Prince', the rose symbolizes love and the complexity of relationships.",
			"tip": "Ask: 'Why did the author choose this word/image? What deeper meaning might it have?'"
		}
	}
}

func get_review_content() -> Dictionary:
	var subject = Dialogic.VAR.selected_subject
	var chapter = Dialogic.VAR.current_chapter
	var quarter = _chapter_to_quarter(chapter)

	if review_content.has(subject) and review_content[subject].has(quarter):
		return review_content[subject][quarter]

	# Fallback for missing content
	push_warning("No review content for ", subject, " ", quarter)
	return {
		"title": "Review the Material",
		"explanation": "Take some time to review the concepts before trying again.",
		"key_concepts": ["Review your notes", "Practice similar problems", "Ask for help if needed"],
		"example": "",
		"tip": "Don't give up! Learning takes practice."
	}
