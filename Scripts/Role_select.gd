extends Control

func _process(_delta: float) -> void:
	if Global.is_role_select and not visible:
		show()
		for child in get_tree().current_scene.get_children():
			if child.is_in_group("Grab"):
				child.is_disabled = true
				child.follow_player = false
				Global.freeze_node(child, true)
		get_tree().paused = true
	elif not Global.is_role_select and visible:
		hide()
		if Global.time_hours >= 10 and Global.is_afternoon:
			Global.reset_time()
		for child in get_tree().current_scene.get_children():
			if child.is_in_group("Grab"):
				child.is_disabled = false
				child.follow_player = false
				Global.freeze_node(child, false)
		get_tree().paused = false
