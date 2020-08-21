extends Sprite

var is_player_colliding: bool = false
var is_open: bool = false

func _ready() -> void:
	Global.freeze_node(self, true)

func _process(_delta: float) -> void:
	if is_player_colliding and Global.dialog_box != null and is_open:
		if not Global.dialog_box.visible and Global.dialog_box.started_dialog == false:
			if Input.is_action_just_pressed("interact"):
				if Global.total_coins < 20 and not Global.bought_dimensional_portal:
					Global.dialog_box.write_text_array(["Welcome to the Shop!", "This portal here costs $20", "You don't have enough money", "Come back later"])
				elif Global.total_coins >= 20 and not Global.bought_dimensional_portal:
					Global.dialog_box.write_text_array(["Welcome to the Shop!", "This portal here costs $20", "Thanks for buying the portal", "See you later"])
					Global.bought_dimensional_portal = true
					Global.total_coins -= 20
				elif Global.bought_dimensional_portal:
					Global.dialog_box.write_text_array(["Welcome to the Shop!", "Sorry but I am out of stock"])
	
	if Global.raw_time_hours >= 9 and Global.raw_time_hours <= 14:
		frame = 0
		is_open = true
	else:
		frame = 1
		is_open = false

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		if area.get_parent().current_role == "father":
			is_player_colliding = true

func _on_Hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		if area.get_parent().current_role == "father":
			is_player_colliding = false
			Global.dialog_box.hide()

func _on_VisibilityNotifier2D_screen_entered() -> void:
	Global.freeze_node(self, false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	Global.freeze_node(self, true)
