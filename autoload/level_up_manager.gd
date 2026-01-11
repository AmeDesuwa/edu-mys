# level_up_manager.gd
extends Node

var level_up_scene = preload("res://scenes/ui/level_up_scene.tscn")
var current_level_up_instance = null

var ability_data = {
	2: {
		"name": "Second Chance",
		"desc": "You can now retry failed minigames once!",
		"icon": "🔄",
		"color": Color(0.306, 0.804, 0.769)
	},
	3: {
		"name": "Score Improvement",
		"desc": "Retry completed minigames to improve your score!",
		"icon": "⭐",
		"color": Color(1.0, 0.902, 0.427)
	},
	4: {
		"name": "Deductive Hint",
		"desc": "Receive 1 hint per minigame when you need guidance!",
		"icon": "💡",
		"color": Color(1.0, 0.420, 0.420)
	},
	5: {
		"name": "Extended Analysis",
		"desc": "Gain +30 seconds on timed challenges!",
		"icon": "⏱️",
		"color": Color(0.584, 0.882, 0.827)
	},
	6: {
		"name": "Double Attempt",
		"desc": "You can now retry failed minigames TWICE!",
		"icon": "🔄",
		"color": Color(0.659, 0.906, 0.812)
	},
	7: {
		"name": "Enhanced Insight",
		"desc": "Receive 2 hints per minigame!",
		"icon": "💡",
		"color": Color(1.0, 0.851, 0.239)
	},
	8: {
		"name": "Master's Focus",
		"desc": "Gain +60 seconds on timed challenges!",
		"icon": "⏱️",
		"color": Color(0.420, 0.812, 0.498)
	},
	9: {
		"name": "Strategic Skip",
		"desc": "Skip challenging sections after 3 failed attempts!",
		"icon": "⏭️",
		"color": Color(0.780, 0.502, 0.980)
	},
	10: {
		"name": "Perfect Detective",
		"desc": "Unlimited retries and all hints available! Complete mastery achieved!",
		"icon": "👑",
		"color": Color(1.0, 0.843, 0.0)
	}
}

func show_level_up(new_level: int):
	if current_level_up_instance:
		return
	
	update_abilities(new_level)
	
	current_level_up_instance = level_up_scene.instantiate()
	get_tree().root.add_child(current_level_up_instance)
	
	var old_level = new_level - 1
	current_level_up_instance.show_level_up(old_level, new_level, ability_data.get(new_level, {}))
	
	await current_level_up_instance.level_up_finished
	
	current_level_up_instance.queue_free()
	current_level_up_instance = null

func update_abilities(level: int):
	match level:
		2:
			Dialogic.VAR.retry_count = 1
		3:
			Dialogic.VAR.can_redo_for_score = true
		4:
			Dialogic.VAR.hint_count = 1
		5:
			Dialogic.VAR.time_bonus = 30
		6:
			Dialogic.VAR.retry_count = 2
		7:
			Dialogic.VAR.hint_count = 2
		8:
			Dialogic.VAR.time_bonus = 60
		9:
			Dialogic.VAR.can_skip_hard = true
		10:
			Dialogic.VAR.retry_count = 999
			Dialogic.VAR.hint_count = 999
