extends KinematicBody2D

onready var initial_position: Vector2 = global_position
onready var collision: CollisionShape2D = $CollisionShape2D

func _process(delta: float) -> void:
	if Global.player != null:
		if global_position.distance_to(Global.player.global_position) < 100:
			global_position.y = lerp(global_position.y, Global.player.global_position.y, delta * 16)
			
			if Global.player.current_role == "child" and Global.player.is_dashing:
				collision.disabled = true
			else:
				collision.disabled = false
		else:
			global_position = lerp(global_position, initial_position, delta * 16)
