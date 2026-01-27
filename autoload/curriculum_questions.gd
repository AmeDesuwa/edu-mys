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
	# =========================================================================
	"math": {
		# Q1: Functions, Operations, Inverse Functions
		"Q1": {
			"pacman": {
				"questions": [
					{
						"question": "What is f(x) = 2x + 3 when x = 4?",
						"correct": "11",
						"wrong": ["8", "9", "14"]
					},
					{
						"question": "What type of function passes the vertical line test?",
						"correct": "Function",
						"wrong": ["Relation", "Equation", "Variable"]
					},
					{
						"question": "What is the domain of f(x) = 1/x?",
						"correct": "x not 0",
						"wrong": ["All reals", "x > 0", "x < 0"]
					},
					{
						"question": "If f(x) = x^2, what is f(3)?",
						"correct": "9",
						"wrong": ["6", "3", "12"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "What is the inverse of f(x) = x + 5?",
						"correct": "x - 5",
						"wrong": ["x + 5", "x / 5", "5x"]
					},
					{
						"question": "A one-to-one function has what property?",
						"correct": "Unique output",
						"wrong": ["No output", "Many outputs", "Zero output"]
					},
					{
						"question": "What is (f + g)(x) if f(x)=2x and g(x)=3x?",
						"correct": "5x",
						"wrong": ["6x", "x", "6x^2"]
					},
					{
						"question": "The range of a function is the set of all?",
						"correct": "Outputs",
						"wrong": ["Inputs", "Variables", "Constants"]
					},
					{
						"question": "What is f(g(x)) called?",
						"correct": "Composition",
						"wrong": ["Addition", "Inverse", "Product"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "What is the notation for an inverse function?",
						"correct": "f^-1(x)",
						"wrong": ["f(x)^-1", "1/f(x)", "-f(x)"]
					},
					{
						"question": "Piecewise functions are defined by?",
						"correct": "Multiple rules",
						"wrong": ["One rule", "No rules", "Equations"]
					},
					{
						"question": "What test checks if an inverse is a function?",
						"correct": "Horizontal line",
						"wrong": ["Vertical line", "Diagonal line", "No test"]
					},
					{
						"question": "The domain of f^-1 is the ___ of f?",
						"correct": "Range",
						"wrong": ["Domain", "Function", "Inverse"]
					},
					{
						"question": "f(f^-1(x)) equals?",
						"correct": "x",
						"wrong": ["0", "1", "f(x)"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "What is (f * g)(x) if f(x)=2 and g(x)=x?",
						"correct": "2x",
						"wrong": ["x+2", "x-2", "x/2"]
					},
					{
						"question": "A function maps each input to how many outputs?",
						"correct": "Exactly one",
						"wrong": ["Two", "Many", "None"]
					},
					{
						"question": "What is 3! (factorial)?",
						"correct": "6",
						"wrong": ["3", "9", "27"]
					},
					{
						"question": "Evaluate: |−7|",
						"correct": "7",
						"wrong": ["-7", "0", "1"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"A function assigns each ", " to exactly one ", "."
				],
				"answers": ["input", "output"],
				"choices": [
					"input", "output", "domain", "range",
					"variable", "constant", "equation", "value"
				]
			}
		},

		# Q2: Exponential & Logarithmic Functions, Business Math
		"Q2": {
			"pacman": {
				"questions": [
					{
						"question": "What is log base 10 of 100?",
						"correct": "2",
						"wrong": ["10", "100", "1"]
					},
					{
						"question": "2^3 equals?",
						"correct": "8",
						"wrong": ["6", "9", "5"]
					},
					{
						"question": "What is the base of natural logarithm?",
						"correct": "e",
						"wrong": ["10", "2", "1"]
					},
					{
						"question": "Simple interest formula uses I = ?",
						"correct": "Prt",
						"wrong": ["P+rt", "P/rt", "Pr+t"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "log(ab) equals log(a) + ?",
						"correct": "log(b)",
						"wrong": ["log(a)", "ab", "a+b"]
					},
					{
						"question": "Compound interest grows how?",
						"correct": "Exponentially",
						"wrong": ["Linearly", "Constantly", "Slowly"]
					},
					{
						"question": "What is e approximately equal to?",
						"correct": "2.718",
						"wrong": ["3.14", "1.618", "2.5"]
					},
					{
						"question": "log(a^n) equals?",
						"correct": "n log(a)",
						"wrong": ["a log(n)", "log(n)", "a^n"]
					},
					{
						"question": "Principal + Interest = ?",
						"correct": "Amount",
						"wrong": ["Rate", "Time", "Sum"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "Exponential decay has a base between?",
						"correct": "0 and 1",
						"wrong": ["1 and 2", "-1 and 0", "2 and 3"]
					},
					{
						"question": "log(1) equals?",
						"correct": "0",
						"wrong": ["1", "10", "e"]
					},
					{
						"question": "Half-life problems use which function?",
						"correct": "Exponential",
						"wrong": ["Linear", "Quadratic", "Constant"]
					},
					{
						"question": "What is the inverse of y = 10^x?",
						"correct": "y = log x",
						"wrong": ["y = 10x", "y = x^10", "y = x/10"]
					},
					{
						"question": "In A = P(1+r)^t, what is t?",
						"correct": "Time",
						"wrong": ["Rate", "Principal", "Amount"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "5^0 equals?",
						"correct": "1",
						"wrong": ["0", "5", "50"]
					},
					{
						"question": "log base 2 of 8 is?",
						"correct": "3",
						"wrong": ["2", "4", "8"]
					},
					{
						"question": "If P = 1000, r = 5%, t = 2, simple I = ?",
						"correct": "100",
						"wrong": ["50", "200", "1000"]
					},
					{
						"question": "Exponential growth has base greater than?",
						"correct": "1",
						"wrong": ["0", "-1", "2"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"The inverse of an ", " function is a ", " function."
				],
				"answers": ["exponential", "logarithmic"],
				"choices": [
					"exponential", "logarithmic", "linear", "quadratic",
					"polynomial", "rational", "constant", "inverse"
				]
			}
		},

		# Q3: Trigonometry
		"Q3": {
			"pacman": {
				"questions": [
					{
						"question": "sin(90°) equals?",
						"correct": "1",
						"wrong": ["0", "-1", "0.5"]
					},
					{
						"question": "cos(0°) equals?",
						"correct": "1",
						"wrong": ["0", "-1", "0.5"]
					},
					{
						"question": "How many degrees in a full circle?",
						"correct": "360",
						"wrong": ["180", "90", "270"]
					},
					{
						"question": "tan = sin divided by?",
						"correct": "cos",
						"wrong": ["tan", "sin", "sec"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "Pi radians equals how many degrees?",
						"correct": "180",
						"wrong": ["360", "90", "270"]
					},
					{
						"question": "The period of sin(x) is?",
						"correct": "2 pi",
						"wrong": ["pi", "pi/2", "4 pi"]
					},
					{
						"question": "sin^2(x) + cos^2(x) = ?",
						"correct": "1",
						"wrong": ["0", "2", "sin(2x)"]
					},
					{
						"question": "What is the amplitude of y = 3sin(x)?",
						"correct": "3",
						"wrong": ["1", "6", "1/3"]
					},
					{
						"question": "csc is the reciprocal of?",
						"correct": "sin",
						"wrong": ["cos", "tan", "sec"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "In which quadrant is sin positive, cos negative?",
						"correct": "II",
						"wrong": ["I", "III", "IV"]
					},
					{
						"question": "What is sin(30°)?",
						"correct": "0.5",
						"wrong": ["1", "0", "0.866"]
					},
					{
						"question": "sec is the reciprocal of?",
						"correct": "cos",
						"wrong": ["sin", "tan", "cot"]
					},
					{
						"question": "The unit circle has radius?",
						"correct": "1",
						"wrong": ["2", "pi", "0"]
					},
					{
						"question": "cot = cos divided by?",
						"correct": "sin",
						"wrong": ["tan", "cos", "sec"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "tan(45°) equals?",
						"correct": "1",
						"wrong": ["0", "2", "0.5"]
					},
					{
						"question": "sin(0°) equals?",
						"correct": "0",
						"wrong": ["1", "-1", "0.5"]
					},
					{
						"question": "How many radians in a full circle?",
						"correct": "2 pi",
						"wrong": ["pi", "4 pi", "pi/2"]
					},
					{
						"question": "cos(180°) equals?",
						"correct": "-1",
						"wrong": ["1", "0", "0.5"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"The ", " function relates an angle to the ratio of opposite over ", "."
				],
				"answers": ["sine", "hypotenuse"],
				"choices": [
					"sine", "cosine", "tangent", "hypotenuse",
					"adjacent", "opposite", "angle", "ratio"
				]
			}
		},

		# Q4: Statistics and Probability
		"Q4": {
			"pacman": {
				"questions": [
					{
						"question": "The mean of 2, 4, 6 is?",
						"correct": "4",
						"wrong": ["2", "6", "12"]
					},
					{
						"question": "Probability ranges from?",
						"correct": "0 to 1",
						"wrong": ["0 to 100", "-1 to 1", "1 to 10"]
					},
					{
						"question": "The median is the ___ value?",
						"correct": "Middle",
						"wrong": ["First", "Last", "Largest"]
					},
					{
						"question": "Mode is the most ___ value?",
						"correct": "Frequent",
						"wrong": ["Average", "Middle", "Large"]
					}
				]
			},
			"runner": {
				"questions": [
					{
						"question": "Standard deviation measures?",
						"correct": "Spread",
						"wrong": ["Center", "Mode", "Median"]
					},
					{
						"question": "P(A and B) for independent events = ?",
						"correct": "P(A) x P(B)",
						"wrong": ["P(A) + P(B)", "P(A) - P(B)", "P(A)/P(B)"]
					},
					{
						"question": "The normal curve is shaped like?",
						"correct": "Bell",
						"wrong": ["Square", "Triangle", "Line"]
					},
					{
						"question": "Variance is standard deviation?",
						"correct": "Squared",
						"wrong": ["Halved", "Doubled", "Cubed"]
					},
					{
						"question": "P(not A) = 1 minus?",
						"correct": "P(A)",
						"wrong": ["P(B)", "0", "1"]
					}
				],
				"answers_needed": 4
			},
			"maze": {
				"questions": [
					{
						"question": "A fair coin flip has P(heads) = ?",
						"correct": "0.5",
						"wrong": ["0.25", "1", "0"]
					},
					{
						"question": "The sum of all probabilities equals?",
						"correct": "1",
						"wrong": ["0", "100", "0.5"]
					},
					{
						"question": "In a normal distribution, mean = ?",
						"correct": "Median",
						"wrong": ["Mode only", "0", "1"]
					},
					{
						"question": "nCr is used for?",
						"correct": "Combinations",
						"wrong": ["Permutations", "Probability", "Mean"]
					},
					{
						"question": "nPr is used for?",
						"correct": "Permutations",
						"wrong": ["Combinations", "Variance", "Mode"]
					}
				]
			},
			"platformer": {
				"questions": [
					{
						"question": "Range = Maximum minus?",
						"correct": "Minimum",
						"wrong": ["Mean", "Mode", "Median"]
					},
					{
						"question": "5! equals?",
						"correct": "120",
						"wrong": ["25", "20", "60"]
					},
					{
						"question": "Probability of impossible event?",
						"correct": "0",
						"wrong": ["1", "0.5", "-1"]
					},
					{
						"question": "Probability of certain event?",
						"correct": "1",
						"wrong": ["0", "0.5", "100"]
					}
				],
				"answers_needed": 3
			},
			"fillinblank": {
				"sentence_parts": [
					"The ", " is the sum of values divided by the ", " of values."
				],
				"answers": ["mean", "count"],
				"choices": [
					"mean", "median", "mode", "count",
					"range", "sum", "total", "number"
				]
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
