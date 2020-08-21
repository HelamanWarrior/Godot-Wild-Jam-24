extends Node2D

export(Vector2) var next_position
export(bool) var dimensional_door_buy = false

onready var sprite: Sprite = $Light2D/Sprite

const spin_speed: int = 150

func _ready() -> void:
	if dimensional_door_buy:
		modulate.a = 0
	
	Global.freeze_node(self, true)

func _process(delta: float) -> void:
	sprite.rotation_degrees += spin_speed * delta
	
	if dimensional_door_buy and Global.bought_dimensional_portal:
		modulate.a = lerp(modulate.a, 1, delta * 4)

func _on_VisibilityNotifier2D_screen_entered() -> void:
	Global.freeze_node(self, false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	Global.freeze_node(self, true)
	
func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player") and modulate.a != 0:
		if Global.camera != null:
			Global.camera.stop_smoothing()
		Sound_manager.play_sound("res://Sounds/Dimension_door.wav")
		
		if Global.transition != null:
			Global.transition.fade_in_out(false)
		yield(get_tree().create_timer(0.8), "timeout")
		area.get_parent().global_position = next_position
