extends Sprite

export(bool) var current_tent = false

var is_player_colliding: bool = false

var player: Object = load("res://Scenes/Player.tscn")

var tent_interact_texture: Texture = load("res://Textures/Tent_interact.png")
var tent_default_texture: Texture = texture

func _ready() -> void:
	if current_tent:
		Global.instance_node_at_location(player, get_tree().current_scene, global_position)
	else:
		modulate.a = 0.25

func _process(delta: float) -> void:
	if not current_tent:
		if is_player_colliding:
			modulate.a = lerp(modulate.a, 0.75, delta * 4)
			
			if Input.is_action_just_pressed("attack"):
				for child in get_tree().current_scene.get_children():
					if child.is_in_group("Tent"):
						child.set_current_tent(false)
				
				print("I am now the current tent")
				set_current_tent(true)
		else:
			modulate.a = lerp(modulate.a, 0.25, delta * 4)
	
	if Global.player != null:
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
	else:
		current_tent = false
		modulate.a = 0.25
