extends Sprite

func _on_Add_frame_timer_timeout() -> void:
	if frame == 0:
		frame += 1
	else:
		frame = 0
