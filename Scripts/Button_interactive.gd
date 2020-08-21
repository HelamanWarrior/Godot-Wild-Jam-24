extends StaticBody2D

onready var raycast: RayCast2D = $RayCast2D
onready var sprite: Sprite = $Sprite

var is_pressed: bool = false

func _ready() -> void:
	Global.freeze_node(self, true)

func _process(_delta: float) -> void:
	if raycast.is_colliding():
		
		if sprite.frame == 0:
			Sound_manager.play_sound("res://Sounds/Button_press.wav")
			if Global.camera != null:
				Global.camera.screen_shake(50)
			sprite.frame = 1
		is_pressed = true
	else:
		sprite.frame = 0
		is_pressed = false

func _on_VisibilityNotifier2D_screen_entered() -> void:
	Global.freeze_node(self, false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	Global.freeze_node(self, true)
