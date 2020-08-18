extends Label

func _process(_delta: float) -> void:
	text = str(Global.time_hours)
	
	if Global.is_afternoon:
		text += " PM"
	else:
		text += " AM"
