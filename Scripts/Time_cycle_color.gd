extends CanvasModulate

export(Gradient) var gradient_time_cycle

func _ready() -> void:
	Global.time_cycle_color = self
	update_colors()

func _exit_tree() -> void:
	Global.time_cycle_color = null

func update_colors() -> void:
	color = find_color(float(Global.raw_time_minutes) / 1320)

func find_color(t):
	for i in range(1, gradient_time_cycle.get_point_count()):
		if t < gradient_time_cycle.get_offset(i):
			var interim_t = 1.0 - ((gradient_time_cycle.get_offset(i) - t)/(gradient_time_cycle.get_offset(i) - gradient_time_cycle.get_offset(i - 1)))

			return gradient_time_cycle.get_color(i - 1).linear_interpolate(gradient_time_cycle.get_color(i), interim_t)
