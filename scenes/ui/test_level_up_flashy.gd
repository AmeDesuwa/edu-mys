extends Node2D

func _ready():
	print("=== FLASHY LEVEL UP TEST ===")
	print("Testing multiple level ups with the new flashy design!")
	print("Starting in 1 second...")
	await get_tree().create_timer(1.0).timeout

	# Test Level 2 (Second Chance ability)
	print("\n--- Testing Level 2: Second Chance ---")
	Dialogic.VAR.conrad_level = 2
	await LevelUpManager.show_level_up(2)
	await get_tree().create_timer(1.0).timeout

	# Test Level 4 (Deductive Hint ability)
	print("\n--- Testing Level 4: Deductive Hint ---")
	Dialogic.VAR.conrad_level = 4
	await LevelUpManager.show_level_up(4)
	await get_tree().create_timer(1.0).timeout

	# Test Level 10 (Maximum Level - Special Golden Style)
	print("\n--- Testing Level 10: MAXIMUM LEVEL ---")
	Dialogic.VAR.conrad_level = 10
	await LevelUpManager.show_level_up(10)

	print("\n=== All tests complete! ===")
	print("The level up system is now FLASHY and STYLIZED!")
