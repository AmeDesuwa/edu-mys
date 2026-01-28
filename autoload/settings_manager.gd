extends Node

# Settings Manager - Loads and applies user settings on game startup

const USER_SETTINGS_PATH := "user://settings.cfg"
const SETTING_LETTER_SPEED := 'dialogic/text/letter_speed'
const SETTING_AUTOADVANCE_ENABLED := 'dialogic/text/autoadvance_enabled'
const SETTING_AUTOADVANCE_FIXED_DELAY := 'dialogic/text/autoadvance_fixed_delay'

var config := ConfigFile.new()
var _auto_advance_enabled := false
var _auto_advance_delay := 1.5

func _ready() -> void:
	load_and_apply_settings()
	# Defer Dialogic settings application to ensure Dialogic is initialized
	call_deferred("_apply_dialogic_settings")

func _apply_dialogic_settings() -> void:
	# Apply auto-advance settings directly to Dialogic
	if Dialogic.Inputs != null and Dialogic.Inputs.auto_advance != null:
		Dialogic.Inputs.auto_advance.enabled_forced = _auto_advance_enabled
		Dialogic.Inputs.auto_advance.fixed_delay = _auto_advance_delay

func load_and_apply_settings() -> void:
	var err = config.load(USER_SETTINGS_PATH)
	if err != OK:
		# No settings file exists yet, use defaults
		return

	# Apply text speed
	var speed_ui = config.get_value("text", "speed_ui", 7.0)
	var letter_speed = (10.0 - speed_ui) / 100.0
	letter_speed = max(letter_speed, 0.001)
	ProjectSettings.set_setting(SETTING_LETTER_SPEED, letter_speed)

	# Apply auto-advance (save values for deferred application)
	_auto_advance_enabled = config.get_value("text", "auto_advance", false)
	_auto_advance_delay = config.get_value("text", "auto_advance_delay", 1.5)
	ProjectSettings.set_setting(SETTING_AUTOADVANCE_ENABLED, _auto_advance_enabled)
	ProjectSettings.set_setting(SETTING_AUTOADVANCE_FIXED_DELAY, _auto_advance_delay)

	# Apply audio volumes
	var master_vol = config.get_value("audio", "master_volume", 100)
	var music_vol = config.get_value("audio", "music_volume", 80)
	var sfx_vol = config.get_value("audio", "sfx_volume", 80)

	_apply_audio_volume("Master", master_vol)
	_apply_audio_volume("Music", music_vol)
	_apply_audio_volume("SFX", sfx_vol)

	# Apply fullscreen
	var fullscreen = config.get_value("display", "fullscreen", false)
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _apply_audio_volume(bus_name: String, volume_percent: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx >= 0:
		if volume_percent <= 0:
			AudioServer.set_bus_mute(bus_idx, true)
		else:
			AudioServer.set_bus_mute(bus_idx, false)
			var db = linear_to_db(volume_percent / 100.0)
			AudioServer.set_bus_volume_db(bus_idx, db)
