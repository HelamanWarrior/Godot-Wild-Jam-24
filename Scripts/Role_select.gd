extends Control

func _process(_delta: float) -> void:
	if Global.is_role_select and not visible:
		show()
		get_tree().paused = true
	elif not Global.is_role_select and visible:
		hide()
		get_tree().paused = false
