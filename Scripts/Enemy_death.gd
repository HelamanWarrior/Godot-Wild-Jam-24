extends CPUParticles2D

func _on_Timer_timeout() -> void:
	queue_free()
