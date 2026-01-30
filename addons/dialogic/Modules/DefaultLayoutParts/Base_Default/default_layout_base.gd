@tool
extends DialogicLayoutBase

## The default layout base scene.

@export var canvas_layer: int = 1
@export var follow_viewport: bool = false

@export_subgroup("Global")
@export var global_bg_color: Color = Color(0.05, 0.05, 0.1, 0.95)
@export var global_font_color: Color = Color(0.95, 0.95, 1.0, 1)
@export_file('*.ttf', '*.tres') var global_font: String = ""
@export var global_font_size: int = 36


func _apply_export_overrides() -> void:
	# apply layer
	set(&'layer', canvas_layer)
	set(&'follow_viewport_enabled', follow_viewport)


