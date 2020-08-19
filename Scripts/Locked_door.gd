extends StaticBody2D

export(bool) var open_by_button = false
export(bool) var stay_opened = false
export(NodePath) var button_path

var has_opened_door: bool = false

onready var button: StaticBody2D = get_node(button_path)
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	Global.freeze_node(self, true)

func _process(_delta: float) -> void:
	if button != null:
		if button.is_pressed and not has_opened_door:
			animation_player.play("Open_door")
			collision_shape.disabled = true
			has_opened_door = true
		elif not button.is_pressed and has_opened_door and not stay_opened:
			animation_player.play_backwards("Open_door")
			collision_shape.disabled = false
			has_opened_door = false

func _on_VisibilityNotifier2D_screen_entered() -> void:
	Global.freeze_node(self, false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	Global.freeze_node(self, true)
