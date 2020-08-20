extends KinematicBody2D

export(int) var health = 3
export(int) var speed = 125
export(int) var gravity_speed = 10
export(int) var jump_speed = 200
export(int) var damage = 1
export(float) var squishiness = 0.15
export(int) var knockback_speed = 300

var velocity: Vector2
var current_health: int = health

var just_hit_floor: bool = false
var is_attacking: bool = false
var is_knocked_back: bool = false

var can_dash: bool = true
var is_dashing: bool = false

const move_angle: int = 15
const dash_speed: int = 200

var attack_hitbox: Object = load("res://Scenes/Player_attack_hitbox.tscn")

var direction = directions.RIGHT

enum directions {
	LEFT,
	RIGHT
}

var current_role: String = "father"

onready var sprite_pivot: Node2D = $Sprite_pivot
onready var sprite: Sprite = $Sprite_pivot/Sprite
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var hit_flash_timer: Timer = $Hit_flash_timer
onready var knockback_recovery: Timer = $Knockback_recovery
onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D
onready var dash_timer: Timer = $Dash_timer
onready var dash_reset_timer: Timer = $Dash_reset_timer

func _ready() -> void:
	Global.player = self
	
	current_role = Global.player_role
	
	if current_role == "mother":
		jump_speed = 300
	elif current_role == "child":
		speed = 175
	
func _exit_tree() -> void:
	Global.player = null

func _process(delta: float) -> void:
	if Global.player != self:
		Global.player = self
	
	if not is_knocked_back:
		if not is_dashing:
			get_input(delta)
		apply_velocity_movement()
	else:
		apply_knocked_back_velocity(delta)
	apply_gravity(delta)
	camera_offset_in_direction(delta)
	
	if current_role == "child":
		check_dash(delta)

func apply_velocity_movement() -> void:
	var applied_velocity := Vector2(velocity.x * speed, velocity.y)
	move_and_slide(applied_velocity, Vector2.UP)

func apply_knocked_back_velocity(delta: float) -> void:
	var applied_velocity := Vector2(velocity.x * knockback_speed, velocity.y)
	move_and_slide(applied_velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, delta * 4)

func check_dash(delta: float):
	if can_dash and Input.is_action_just_pressed("attack"):
		if direction == directions.RIGHT:
			velocity.x = 4
			
		elif direction == directions.LEFT:
			velocity.x = -4
		
		hitbox_collision.disabled = true
		dash_timer.start()
		dash_reset_timer.start()
		is_dashing = true
		
		can_dash = false

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity_speed
		just_hit_floor = false
		sprite_pivot.scale = lerp(sprite_pivot.scale, Vector2(1, 1) + Vector2(-squishiness, squishiness), delta)
	elif not is_knocked_back:
		velocity.y = 2
		if not just_hit_floor:
			sprite_pivot.scale = Vector2(1, 1) + Vector2(squishiness, -squishiness)
			just_hit_floor = true
		sprite_pivot.scale = lerp(sprite_pivot.scale, Vector2(1, 1), delta * 8)

func get_input(delta: float) -> void:
	var x_input: int = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	velocity.x = x_input
	
	if velocity.x != 0:
		if not is_attacking:
			animation_player.play(current_role + "_run")
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, velocity.x * move_angle, delta * 8)
		
		if velocity.x == 1:
			sprite.flip_h = false
			direction = directions.RIGHT
		else:
			sprite.flip_h = true
			direction = directions.LEFT
	else:
		if animation_player.current_animation != "father_attack":
			animation_player.play(current_role + "_idle")
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, 0, delta * 8)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
	
	if Input.is_action_just_pressed("attack") and current_role == "father":
		animation_player.play("father_attack")
		is_attacking = true
		
		if direction == directions.RIGHT:
			sprite.rotation_degrees = move_angle
		else:
			sprite.rotation_degrees = -move_angle

func camera_offset_in_direction(delta: float) -> void:
	if Global.camera != null:
		if direction == directions.RIGHT:
			Global.camera.offset.x = lerp(Global.camera.offset.x, 30, delta * 2)
		elif direction == directions.LEFT:
			Global.camera.offset.x = lerp(Global.camera.offset.x, -30, delta * 2)

func create_damage_hitbox() -> void:
	if direction == directions.RIGHT:
		var attack_hitbox_instance: Area2D = Global.instance_node_at_location(attack_hitbox, get_tree().current_scene, Vector2(global_position.x + 14, global_position.y - 7))
		attack_hitbox_instance.damage = damage
	elif direction == directions.LEFT:
		var attack_hitbox_instance: Area2D = Global.instance_node_at_location(attack_hitbox, get_tree().current_scene, Vector2(global_position.x - 14, global_position.y - 7))
		attack_hitbox_instance.damage = damage

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "father_attack":
		is_attacking = false

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy") and not is_knocked_back and not area.get_parent().is_knocked_back:
		current_health -= 1
		
		sprite.material.set_shader_param("whitening", 1)
		hit_flash_timer.start()
		
		knockback_recovery.start()
		
		is_knocked_back = true
		
		if current_health <= 0:
			Global.is_game_over = true
			queue_free()
		
		if global_position.x > area.global_position.x:
			velocity.x = 1
			velocity.y = -knockback_speed * 0.5
			sprite.rotation_degrees = -15
		else:
			velocity.x = -1
			velocity.y = -knockback_speed * 0.5
			sprite.rotation_degrees = 15

func _on_Knockback_recovery_timeout() -> void:
	is_knocked_back = false
	
func _on_Hit_flash_timer_timeout() -> void:
	sprite.material.set_shader_param("whitening", 0)

func _on_Dash_reset_timer_timeout() -> void:
	can_dash = true
	hitbox_collision.disabled = false

func _on_Dashtimer_timeout() -> void:
	is_dashing = false
