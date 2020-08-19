extends Sprite

var is_player_colliding: bool = false

func _ready() -> void:
	Global.freeze_node(self, true)

func _process(_delta: float) -> void:
	if is_player_colliding and Global.dialog_box != null:
		if not Global.dialog_box.visible and Global.dialog_box.started_dialog == false:
			if Input.is_action_just_pressed("interact"):
				Global.dialog_box.write_text_array(["Welcome to the Shop!", "This gun here costs $25"])

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player") and area.get_parent().current_role == "father":
		is_player_colliding = true

func _on_Hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player") and area.get_parent().current_role == "father":
		is_player_colliding = false
		Global.dialog_box.hide()

func _on_VisibilityNotifier2D_screen_entered() -> void:
	Global.freeze_node(self, false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	Global.freeze_node(self, true)
