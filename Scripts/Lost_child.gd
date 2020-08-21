extends KinematicBody2D

var velocity: Vector2

export(int) var lost_child_number = 1

var is_player_colliding: bool = false
var follow_player: bool = false
var can_interact: bool = false

var is_disabled: bool = false

const gravity_speed: int = 10

onready var check_interact: Timer = $Check_interact
onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	if lost_child_number == 2:
		sprite.texture = load("res://Textures/Player_5.png")
	
	Global.freeze_node(self, true)

func _process(delta: float) -> void:
	if not is_disabled:
		if Input.is_action_just_pressed("interact") and is_player_colliding:
			can_interact = false
			check_interact.start()
			follow_player = true
			
			is_player_colliding = false
		
		if follow_player and Global.player != null:
			collision_shape.disabled = true
			global_position = Vector2(Global.player.global_position.x, Global.player.global_position.y - 15)
			rotation_degrees = Global.player.sprite.rotation_degrees
			
			sprite.flip_h = Global.player.sprite.flip_h
			
			if Input.is_action_just_pressed("interact"):
				if can_interact:
					follow_player = false
		else:
			collision_shape.disabled = false
			rotation_degrees = lerp(rotation_degrees, 0, delta * 8)
			
			if not is_on_floor():
				velocity.y += gravity_speed
			else:
				velocity.y = 0
			
			move_and_slide(velocity, Vector2.UP)

func _on_Pickup_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player") and not follow_player and not is_disabled:
		is_player_colliding = true

func _on_Pickup_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		is_player_colliding = false

func _on_VisibilityNotifier2D_screen_entered() -> void:
	Global.freeze_node(self, false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	Global.freeze_node(self, true)

func _on_Check_interact_timeout() -> void:
	can_interact = true
