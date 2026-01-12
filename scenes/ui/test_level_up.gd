extends Node2D

func _ready():
	print("Starting level up test in 1 second...")
	await get_tree().create_timer(1.0).timeout
	
	# Set Conrad's level to 2 (so the level up will show 1 → 2)
	Dialogic.VAR.conrad_level = 2
	
	print("Showing level up screen...")
	await LevelUpManager.show_level_up(2)
	
	print("Level up finished! Test complete!")
