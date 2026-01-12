# DialogicEffectsManager.gd
# Comprehensive visual effects system for Dialogic timelines
extends Node

# Effect nodes - will be created automatically
var screen_overlay: ColorRect
var particles_container: Node2D
var camera: Camera2D

# Effect state
var is_shaking: bool = false
var original_camera_offset: Vector2

func _ready():
	_setup_effect_nodes()
	_connect_dialogic_signals()

func _setup_effect_nodes():
	# Create screen overlay for flashes and fades
	screen_overlay = ColorRect.new()
	screen_overlay.name = "ScreenOverlay"
	screen_overlay.color = Color(0, 0, 0, 0)
	screen_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(screen_overlay)
	
	# Make it cover the whole screen
	screen_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# Create particles container
	particles_container = Node2D.new()
	particles_container.name = "ParticlesContainer"
	add_child(particles_container)
	
	# Try to find camera
	camera = get_viewport().get_camera_2d()
	if camera:
		original_camera_offset = camera.offset

func _connect_dialogic_signals():
	# Connect to Dialogic signals
	if Dialogic.signal_event:
		Dialogic.signal_event.connect(_on_dialogic_signal)
	
	if Dialogic.text_signal:
		Dialogic.text_signal.connect(_on_text_signal)

func _on_dialogic_signal(argument: String):
	"""Main signal handler for effects"""
	var parts = argument.split(":")
	var effect_name = parts[0]
	var params = parts.slice(1) if parts.size() > 1 else []
	
	match effect_name:
		# Screen effects
		"shake":
			var intensity = float(params[0]) if params.size() > 0 else 1.0
			var duration = float(params[1]) if params.size() > 1 else 0.5
			shake_screen(intensity, duration)
		
		"shake_stop":
			stop_shake()
		
		"flash":
			var color_name = params[0] if params.size() > 0 else "white"
			var duration = float(params[1]) if params.size() > 1 else 0.3
			flash_screen(color_name, duration)
		
		"fade_out":
			var duration = float(params[0]) if params.size() > 0 else 1.0
			fade_out(duration)
		
		"fade_in":
			var duration = float(params[0]) if params.size() > 0 else 1.0
			fade_in(duration)
		
		"tint":
			var color_name = params[0] if params.size() > 0 else "white"
			var intensity = float(params[1]) if params.size() > 1 else 0.3
			var duration = float(params[2]) if params.size() > 2 else 0.5
			tint_screen(color_name, intensity, duration)
		
		"tint_clear":
			var duration = float(params[0]) if params.size() > 0 else 0.5
			clear_tint(duration)
		
		# Camera effects
		"zoom":
			var zoom_amount = float(params[0]) if params.size() > 0 else 1.5
			var duration = float(params[1]) if params.size() > 1 else 1.0
			zoom_camera(zoom_amount, duration)
		
		"zoom_reset":
			var duration = float(params[0]) if params.size() > 0 else 1.0
			reset_zoom(duration)
		
		"pan":
			var x = float(params[0]) if params.size() > 0 else 0.0
			var y = float(params[1]) if params.size() > 1 else 0.0
			var duration = float(params[2]) if params.size() > 2 else 1.0
			pan_camera(Vector2(x, y), duration)
		
		"pan_reset":
			var duration = float(params[0]) if params.size() > 0 else 1.0
			reset_pan(duration)
		
		# Particle effects
		"particles":
			var particle_type = params[0] if params.size() > 0 else "sparkles"
			var duration = float(params[1]) if params.size() > 1 else 2.0
			spawn_particles(particle_type, duration)
		
		"particles_stop":
			stop_particles()
		
		# Chromatic aberration / glitch
		"glitch":
			var intensity = float(params[0]) if params.size() > 0 else 1.0
			var duration = float(params[1]) if params.size() > 1 else 0.5
			glitch_effect(intensity, duration)
		
		# Vignette
		"vignette":
			var intensity = float(params[0]) if params.size() > 0 else 0.5
			var duration = float(params[1]) if params.size() > 1 else 1.0
			vignette_effect(intensity, duration)
		
		"vignette_clear":
			clear_vignette()

func _on_text_signal(argument: String):
	"""Handler for inline text signals"""
	_on_dialogic_signal(argument)

# ============================================
# SCREEN SHAKE
# ============================================

func shake_screen(intensity: float = 1.0, duration: float = 0.5):
	"""Shake the screen/camera"""
	if not camera:
		return
	
	is_shaking = true
	var shake_tween = create_tween()
	var shake_count = int(duration * 20)  # 20 shakes per second
	
	for i in range(shake_count):
		var offset = Vector2(
			randf_range(-10, 10) * intensity,
			randf_range(-10, 10) * intensity
		)
		shake_tween.tween_property(camera, "offset", original_camera_offset + offset, duration / shake_count)
	
	shake_tween.tween_property(camera, "offset", original_camera_offset, 0.1)
	shake_tween.finished.connect(func(): is_shaking = false)

func stop_shake():
	"""Stop screen shake immediately"""
	if camera and is_shaking:
		camera.offset = original_camera_offset
		is_shaking = false

# ============================================
# FLASH EFFECTS
# ============================================

func flash_screen(color_name: String = "white", duration: float = 0.3):
	"""Flash the screen with a color"""
	var color = _get_color_from_name(color_name)
	
	var tween = create_tween()
	screen_overlay.color = Color(color.r, color.g, color.b, 0)
	tween.tween_property(screen_overlay, "color:a", 1.0, duration / 2)
	tween.tween_property(screen_overlay, "color:a", 0.0, duration / 2)

# ============================================
# FADE EFFECTS
# ============================================

func fade_out(duration: float = 1.0):
	"""Fade to black"""
	var tween = create_tween()
	screen_overlay.color = Color(0, 0, 0, 0)
	tween.tween_property(screen_overlay, "color:a", 1.0, duration)

func fade_in(duration: float = 1.0):
	"""Fade from black"""
	var tween = create_tween()
	screen_overlay.color = Color(0, 0, 0, 1)
	tween.tween_property(screen_overlay, "color:a", 0.0, duration)

# ============================================
# TINT EFFECTS
# ============================================

func tint_screen(color_name: String, intensity: float = 0.3, duration: float = 0.5):
	"""Apply a color tint overlay"""
	var color = _get_color_from_name(color_name)
	color.a = intensity
	
	var tween = create_tween()
	tween.tween_property(screen_overlay, "color", color, duration)

func clear_tint(duration: float = 0.5):
	"""Remove color tint"""
	var tween = create_tween()
	tween.tween_property(screen_overlay, "color", Color(0, 0, 0, 0), duration)

# ============================================
# CAMERA EFFECTS
# ============================================

func zoom_camera(zoom_amount: float = 1.5, duration: float = 1.0):
	"""Zoom camera in/out"""
	if not camera:
		return
	
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2(zoom_amount, zoom_amount), duration)

func reset_zoom(duration: float = 1.0):
	"""Reset camera zoom to default"""
	if not camera:
		return
	
	var tween = create_tween()
	tween.tween_property(camera, "zoom", Vector2(1, 1), duration)

func pan_camera(offset: Vector2, duration: float = 1.0):
	"""Pan camera to a position"""
	if not camera:
		return
	
	var tween = create_tween()
	tween.tween_property(camera, "offset", original_camera_offset + offset, duration)

func reset_pan(duration: float = 1.0):
	"""Reset camera pan"""
	if not camera:
		return
	
	var tween = create_tween()
	tween.tween_property(camera, "offset", original_camera_offset, duration)

# ============================================
# PARTICLE EFFECTS
# ============================================

func spawn_particles(particle_type: String = "sparkles", duration: float = 2.0):
	"""Spawn particle effects"""
	var particles = CPUParticles2D.new()
	particles_container.add_child(particles)
	
	# Position at screen center
	var viewport_size = get_viewport().get_visible_rect().size
	particles.position = viewport_size / 2
	
	# Configure based on type
	match particle_type:
		"sparkles":
			_setup_sparkles(particles)
		"snow":
			_setup_snow(particles)
		"rain":
			_setup_rain(particles)
		"leaves":
			_setup_leaves(particles)
		"hearts":
			_setup_hearts(particles)
		"stars":
			_setup_stars(particles)
	
	particles.emitting = true
	
	# Auto-remove after duration
	await get_tree().create_timer(duration).timeout
	particles.emitting = false
	await get_tree().create_timer(particles.lifetime).timeout
	particles.queue_free()

func _setup_sparkles(particles: CPUParticles2D):
	particles.amount = 50
	particles.lifetime = 1.5
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	particles.emission_sphere_radius = 200
	particles.direction = Vector2(0, -1)
	particles.spread = 180
	particles.gravity = Vector2(0, -50)
	particles.initial_velocity_min = 50
	particles.initial_velocity_max = 100
	particles.scale_amount_min = 0.5
	particles.scale_amount_max = 2.0
	particles.color = Color(1, 1, 0.5, 1)

func _setup_snow(particles: CPUParticles2D):
	particles.amount = 100
	particles.lifetime = 3.0
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	particles.emission_rect_extents = Vector2(get_viewport().get_visible_rect().size.x, 10)
	particles.direction = Vector2(0, 1)
	particles.spread = 15
	particles.gravity = Vector2(0, 50)
	particles.initial_velocity_min = 20
	particles.initial_velocity_max = 50
	particles.color = Color.WHITE

func _setup_rain(particles: CPUParticles2D):
	particles.amount = 200
	particles.lifetime = 1.0
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	particles.emission_rect_extents = Vector2(get_viewport().get_visible_rect().size.x, 10)
	particles.direction = Vector2(0.2, 1)
	particles.spread = 5
	particles.gravity = Vector2(0, 500)
	particles.initial_velocity_min = 200
	particles.initial_velocity_max = 300
	particles.scale_amount_min = 0.3
	particles.scale_amount_max = 0.6
	particles.color = Color(0.7, 0.8, 1, 0.8)

func _setup_leaves(particles: CPUParticles2D):
	particles.amount = 30
	particles.lifetime = 3.0
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	particles.emission_rect_extents = Vector2(get_viewport().get_visible_rect().size.x, 10)
	particles.direction = Vector2(0, 1)
	particles.spread = 45
	particles.gravity = Vector2(0, 30)
	particles.initial_velocity_min = 30
	particles.initial_velocity_max = 60
	particles.angular_velocity_min = -90
	particles.angular_velocity_max = 90
	particles.color = Color(0.8, 0.5, 0.2, 1)

func _setup_hearts(particles: CPUParticles2D):
	particles.amount = 20
	particles.lifetime = 2.0
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	particles.emission_sphere_radius = 100
	particles.direction = Vector2(0, -1)
	particles.spread = 30
	particles.gravity = Vector2(0, -30)
	particles.initial_velocity_min = 50
	particles.initial_velocity_max = 100
	particles.color = Color(1, 0.3, 0.5, 1)

func _setup_stars(particles: CPUParticles2D):
	particles.amount = 40
	particles.lifetime = 1.5
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	particles.emission_sphere_radius = 150
	particles.direction = Vector2(0, 0)
	particles.spread = 180
	particles.gravity = Vector2.ZERO
	particles.initial_velocity_min = 100
	particles.initial_velocity_max = 200
	particles.scale_amount_min = 0.8
	particles.scale_amount_max = 2.5
	particles.color = Color(1, 1, 0.8, 1)

func stop_particles():
	"""Stop all active particles"""
	for child in particles_container.get_children():
		if child is CPUParticles2D:
			child.emitting = false

# ============================================
# GLITCH EFFECT
# ============================================

func glitch_effect(intensity: float = 1.0, duration: float = 0.5):
	"""Create a glitch/distortion effect"""
	var glitch_count = int(duration * 10)
	
	for i in range(glitch_count):
		# Random offset
		if camera:
			var offset = Vector2(
				randf_range(-20, 20) * intensity,
				randf_range(-5, 5) * intensity
			)
			camera.offset = original_camera_offset + offset
		
		# Random color flash
		var colors = [Color.RED, Color.GREEN, Color.BLUE, Color.CYAN, Color.MAGENTA]
		screen_overlay.color = colors[randi() % colors.size()]
		screen_overlay.color.a = randf_range(0.1, 0.3) * intensity
		
		await get_tree().create_timer(duration / glitch_count).timeout
	
	# Reset
	if camera:
		camera.offset = original_camera_offset
	screen_overlay.color = Color(0, 0, 0, 0)

# ============================================
# VIGNETTE EFFECT
# ============================================

var vignette_shader: ColorRect = null

func vignette_effect(intensity: float = 0.5, duration: float = 1.0):
	"""Apply vignette darkening around edges"""
	if not vignette_shader:
		vignette_shader = ColorRect.new()
		vignette_shader.name = "Vignette"
		vignette_shader.set_anchors_preset(Control.PRESET_FULL_RECT)
		vignette_shader.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(vignette_shader)
		
		# Simple radial gradient shader
		var shader_code = """
shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec2 uv = UV - 0.5;
	float dist = length(uv);
	float vignette = smoothstep(0.5, 0.5 - intensity * 0.5, dist);
	COLOR.rgb *= vignette;
}
"""
		var shader = Shader.new()
		shader.code = shader_code
		var material = ShaderMaterial.new()
		material.shader = shader
		vignette_shader.material = material
	
	var material = vignette_shader.material as ShaderMaterial
	var tween = create_tween()
	tween.tween_method(
		func(value): material.set_shader_parameter("intensity", value),
		0.0,
		intensity,
		duration
	)

func clear_vignette():
	"""Remove vignette effect"""
	if vignette_shader:
		vignette_shader.queue_free()
		vignette_shader = null

# ============================================
# HELPER FUNCTIONS
# ============================================

func _get_color_from_name(color_name: String) -> Color:
	"""Convert color name to Color"""
	match color_name.to_lower():
		"white": return Color.WHITE
		"black": return Color.BLACK
		"red": return Color.RED
		"green": return Color.GREEN
		"blue": return Color.BLUE
		"yellow": return Color.YELLOW
		"cyan": return Color.CYAN
		"magenta": return Color.MAGENTA
		"orange": return Color.ORANGE
		"purple": return Color.PURPLE
		"pink": return Color.PINK
		_: return Color.WHITE
