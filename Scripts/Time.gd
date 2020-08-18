extends Label

func _process(_delta: float) -> void:
	text = str(Global.time_hours) + ":"
	
	if str(Global.time_minutes).length() <= 1:
		text += "0" + str(Global.time_minutes)
	else:
		text += str(Global.time_minutes)
	
	if Global.is_afternoon:
		text += " PM"
	else:
		text += " AM"
