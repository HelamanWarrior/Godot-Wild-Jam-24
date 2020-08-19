extends KinematicBody2D

export(int) var health = 3
export(int) var speed = 50
export(int) var knockback_speed = 200
export(int) var damage = 1
export(float) var knockback_recovery_time = 0.5

export(Animation) var idle_animation
export(Animation) var walk_animation

var velocity: Vector2
var current_health: int = health

var is_knocked_back: bool = false
var just_hit_floor: bool = false

var direction = directions.RIGHT

onready var knockback_recovery: Timer = $Knockback_recovery
onready var sprite: Sprite = $Sprite_pivot/Sprite
onready var hit_flash_timer: Timer = $Hit_flash_timer
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var light: Light2D = $Light2D

enum directions {
	LEFT,
	RIGHT
}

const gravity_speed = 5

func _ready() -> void:
	knockback_recovery.wait_time = knockback_recovery_time
	Global.freeze_node(self, true)

func _process(delta: float) -> void:
	if velocity.x == 1:
		direction = directions.RIGHT
		
		if walk_animation != null:
			animation_player.play(walk_animation.resource_name)
	elif velocity.x == -1:
		direction = directions.LEFT
		
		if walk_animation != null:
			animation_player.play(walk_animation.resource_name)
	else:
		if idle_animation != null:
			animation_player.play(idle_animation.resource_name)
	
	if not is_on_floor():
		velocity.y += gravity_speed * delta
		just_hit_floor = false
	elif not is_knocked_back:
		velocity.y = 2
	
	if is_on_floor():
		if not just_hit_floor:
			sprite.rotation_degrees = 0
			just_hit_floor = true
	
	if not is_knocked_back:
		move_and_slide(velocity * speed, Vector2.UP)
		
		if current_health <= 0:
			queue_free()
	else:
		move_and_slide(velocity * knockback_speed, Vector2.UP)
		velocity.x = lerp(velocity.x, 0, delta * 4)
		
		if abs(velocity.x) < 0.15:
			velocity.x = 0

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy_damager") and Global.player != null and not is_knocked_back:
		if global_position > Global.player.global_position:
			velocity.x = 1
			velocity.y = -0.75
			sprite.rotation_degrees = -15
		else:
			velocity.x = -1
			velocity.y = -0.75
			sprite.rotation_degrees = 15
		
		knockback_recovery.start()
		
		current_health -= area.damage
		
		sprite.material.set_shader_param("whitening", 1)
		hit_flash_timer.start()
		
		is_knocked_back = true

func _on_Knockback_recovery_timeout() -> void:
	is_knocked_back = false

func _on_Hit_flash_timer_timeout() -> void:
	sprite.material.set_shader_param("whitening", 0)

func _on_VisibilityNotifier2D_screen_entered() -> void:
	Global.freeze_node(self, false)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	Global.freeze_node(self, true)

