extends Area2D

export(float) var hit_time = 0.1
export(int) var damage = 1

onready var hit_time_timer: Timer = $Hit_time_timer

func _ready() -> void:
	hit_time_timer.wait_time = hit_time
	hit_time_timer.start()

func _on_Hit_time_timer_timeout() -> void:
	queue_free()
