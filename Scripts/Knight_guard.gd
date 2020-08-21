extends KinematicBody2D

onready var initial_position: Vector2 = global_position
onready var collision: CollisionShape2D = $CollisionShape2D
onready var sprite: Sprite = $Sprite

var is_player_colliding: bool = false
var player_colliding_right: bool = false
var player_colliding_left: bool = false

var started_dialog: bool = false
var played_dialog: bool = false

onready var default_texture: Texture = sprite.texture
var texture_select: Texture = load("res://Textures/Knight_guard_selected.png")

func _process(delta: float) -> void:
	if Global.player != null and not started_dialog:
		if global_position.distance_to(Global.player.global_position) < 100:
			global_position.y = lerp(global_position.y, Global.player.global_position.y, delta * 16)
			
			if Global.player.current_role == "child" and Global.player.is_dashing:
				collision.disabled = true
			else:
				collision.disabled = false
		else:
			global_position = lerp(global_position, initial_position, delta * 16)
	
	if is_player_colliding:
		if is_player_colliding and Global.dialog_box != null:
			if not Global.dialog_box.visible and Global.dialog_box.started_dialog == false:
				if Input.is_action_just_pressed("interact"):
					if player_colliding_right == true and not played_dialog:
						Global.dialog_box.write_text_array(["You shall not pass!", "This area is dangerous"])
					
					if player_colliding_left == true and not played_dialog:
						Global.dialog_box.write_text_array(["I guess you can pass", "You can go", "But beware this area is dangerous"])
						played_dialog = true
						started_dialog = true
	
	if Global.dialog_box != null:
		if started_dialog and Global.dialog_box.visible == false:
			modulate.a = lerp(modulate.a, 0, delta)
			collision.disabled = true
			
			if modulate.a <= 0.005:
				queue_free()

func _on_Hitbox_right_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_player_colliding = true
		player_colliding_right = true
		sprite.texture = texture_select

func _on_Hitbox_right_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_player_colliding = false
		player_colliding_right = false
		sprite.texture = default_texture

func _on_Hitbox_left_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_player_colliding = true
		player_colliding_left = true
		sprite.texture = texture_select
		
func _on_Hitbox_left_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_player_colliding = false
		player_colliding_left = false
		sprite.texture = default_texture
