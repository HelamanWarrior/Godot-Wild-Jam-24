extends "res://Scripts/Enemy_core.gd"

func _process(_delta: float) -> void:
	if Global.player != null:
		if global_position.distance_to(Global.player.global_position) < 200:
			if not is_knocked_back:
				if global_position < Global.player.global_position:
					velocity.x = 1
					sprite.flip_h = false
				else:
					velocity.x = -1
					sprite.flip_h = true
		else:
			velocity.x = 0
