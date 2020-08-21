extends Camera2D

var screen_shake: bool = false
var shake_intensity: int = 0
var screen_shake_offset: Vector2

onready var screen_shake_timer: Timer = $Screen_shake_timer

func _ready() -> void:
	follow_player_position()
	Global.camera = self

func _exit_tree() -> void:
	Global.camera = null

func _process(delta: float) -> void:
	follow_player_position()
	
	if screen_shake:
		screen_shake_offset.x += rand_range(-shake_intensity, shake_intensity) * delta
		screen_shake_offset.y += rand_range(-shake_intensity, shake_intensity) * delta
		
		zoom.x = lerp(zoom.x, 1 - (shake_intensity * 0.0015), delta * 16)
		zoom.y = zoom.x
		smoothing_enabled = false
	else:
		screen_shake_offset = Vector2(0, 0)
		zoom.x = lerp(zoom.x, 1, delta * 16)
		zoom.y = zoom.x
		smoothing_speed = 5
		smoothing_enabled = true

func screen_shake(intensity: int) -> void:
	shake_intensity = intensity
	screen_shake_timer.start()
	screen_shake = true

func stop_smoothing() -> void:
	smoothing_enabled = false
	yield(get_tree().create_timer(0.1), "timeout")
	smoothing_enabled = true

func follow_player_position() -> void:
	if Global.player != null:
		global_position = Global.player.global_position + screen_shake_offset

func _on_Screen_shake_timer_timeout() -> void:
	shake_intensity = 0
	screen_shake = false
