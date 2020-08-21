extends Control

func _process(_delta: float) -> void:
	if Global.is_game_over:
		show()
		get_tree().paused = true
	else:
		hide()
		get_tree().paused = false

func _on_Restart_button_pressed() -> void:
	Global.is_game_over = false
	Global.reset()
	Global.is_role_select = true
	get_tree().reload_current_scene()
