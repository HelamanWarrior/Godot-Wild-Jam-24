extends Sprite

func _process(_delta: float) -> void:
	if Global.player != null:
		frame = Global.player.current_health
