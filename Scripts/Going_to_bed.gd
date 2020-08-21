extends Control

onready var going_to_bed_text: Label = $Going_to_bed_text

var started: bool = false

func _ready() -> void:
	visible = false
	Global.going_to_bed = self

func _exit_tree() -> void:
	Global.going_to_bed = null

func start() -> void:
	Global.reset_time()
	started = true
	visible = true
	for i in range(4):
		yield(get_tree().create_timer(0.5), "timeout")
		going_to_bed_text.text += "."
	visible = false
	Global.is_role_select = true
	started = false
