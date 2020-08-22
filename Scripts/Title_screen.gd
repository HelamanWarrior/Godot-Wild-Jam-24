extends Control

func _on_Play_button_pressed() -> void:
	Sound_manager.play_sound("res://Sounds/Select_role.wav")
	get_tree().change_scene("res://Scenes/World.tscn")
