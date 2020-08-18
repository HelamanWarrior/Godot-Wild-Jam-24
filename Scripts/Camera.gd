extends Camera2D

func _ready() -> void:
	follow_player_position()
	Global.camera = self

func _exit_tree() -> void:
	Global.camera = null

func _process(delta: float) -> void:
	follow_player_position()

func follow_player_position() -> void:
	if Global.player != null:
		global_position = Global.player.global_position
