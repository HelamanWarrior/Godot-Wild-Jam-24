extends Sprite

export(bool) var current_tent = false

var is_player_colliding: bool = false

var player: Object = load("res://Scenes/Player.tscn")

var tent_interact_texture: Texture = load("res://Textures/Tent_interact.png")
var tent_default_texture: Texture = texture

onready var light: Light2D = $Light2D
onready var change_role: Label = $Change_role
onready var children_found: Label = $Children_found

func _ready() -> void:
	Global.freeze_node(self, true)
	change_role.visible = false
	children_found.visible = false

func _process(delta: float) -> void:
	children_found.text = "Children Found: " + str(int(Global.lost_child_1_found) + int(Global.lost_child_2_found)) + "/2"
	
	if not current_tent:
		if is_player_colliding and Global.player != null:
			modulate.a = lerp(modulate.a, 0.75, delta * 4)
			
			if Input.is_action_just_pressed("interact") and Global.player.current_role == "mother":
				for child in get_tree().current_scene.get_children():
					if child.is_in_group("Tent"):
						child.set_current_tent(false)
				
				set_current_tent(true)
		else:
			modulate.a = lerp(modulate.a, 0.25, delta * 4)
	else:
		if Global.instance_player_from_tent:
			Global.instance_node_at_location(player, get_tree().current_scene, global_position)
			Global.instance_player_from_tent = false
		
		if Global.player != null:
			if global_position.distance_to(Global.player.global_position) < 50:
				change_role.visible = true
				children_found.visible = true
				if Input.is_action_just_pressed("interact"):
					Sound_manager.play_sound("res://Sounds/Change_role.wav")
					Global.is_role_select = true
			else:
				children_found.visible = false
				change_role.visible = false
	
	if Global.player != null and Global.player.current_role == "mother":
		if global_position.distance_to(Global.player.global_position) > 50:
			is_player_colliding = false
			
			texture = tent_default_texture
		else:
			is_player_colliding = true
			
			if not current_tent:
				texture = tent_interact_texture
				
func set_current_tent(enable: bool):
	if enable:
		current_tent = true
		modulate.a = 1
		light.enabled = true
	else:
		current_tent = false
		modulate.a = 0.25
		light.enabled = false


func _on_VisibilityNotifier2D_screen_entered() -> void:
	Global.freeze_node(self, false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	Global.freeze_node(self, true)

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Lost_child"):
		if area.get_parent().lost_child_number == 1:
			Global.lost_child_1_found = true
		else:
			Global.lost_child_2_found = true

func _on_Hitbox_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Lost_child"):
		if area.get_parent().lost_child_number == 1:
			Global.lost_child_1_found = false
		else:
			Global.lost_child_2_found = false
