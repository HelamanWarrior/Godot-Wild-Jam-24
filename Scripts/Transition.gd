extends ColorRect

onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Global.transition = self
	modulate.a = 0

func _exit_tree() -> void:
	Global.transition = null

func fade(out: bool):
	if not out:
		animation_player.play("Fade")
	else:
		animation_player.play_backwards("Fade")
	yield(animation_player, "animation_finished")
	return true

func fade_in_out(reverse: bool):
	if not reverse:
		animation_player.play_backwards("Fade")
	else:
		animation_player.play("Fade")
		
	yield(animation_player, "animation_finished")
	
	if not reverse:
		animation_player.play("Fade")
	else:
		animation_player.play_backwards("Fade")
	return true
