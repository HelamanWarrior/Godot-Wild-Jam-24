extends ColorRect

onready var dialog: Label = $Dialog

var dialog_strings: Array = []

var current_dialog_index: int = 0
var max_dialog_index: int = 0

var started_dialog: bool = false

func _ready() -> void:
	Global.dialog_box = self

func _exit_tree() -> void:
	Global.dialog_box = null

func _process(_delta: float) -> void:
	if visible:
		if current_dialog_index <= dialog_strings.size() - 1:
			if Input.is_action_pressed("interact"):
				if dialog.text.length() == dialog_strings[current_dialog_index].length():
					dialog.text = ""
					current_dialog_index += 1
					if current_dialog_index <= dialog_strings.size() - 1:
						write_text(dialog_strings[current_dialog_index])
					else:
						reset()
		else:
			reset()

func reset() -> void:
	visible = false
	yield(get_tree().create_timer(0.05), "timeout")
	started_dialog = false
	dialog.text = ""
	current_dialog_index = 0
	max_dialog_index = 0
	dialog_strings.clear()

func write_text(string: String) -> void:
	visible = true
	dialog.text = ""
	for text in string:
		if text != " ":
			Sound_manager.play_sound("res://Sounds/Dialog_type.wav")
		dialog.text += text
		yield(get_tree().create_timer(0.05), "timeout")

func write_text_array(dialog_array: Array) -> void:
	visible = true
	started_dialog = true
	dialog.text = ""
	max_dialog_index
	
	dialog_strings = dialog_array
	
	for text in dialog_strings[0]:
		if text != " ":
			Sound_manager.play_sound("res://Sounds/Dialog_type.wav")
		dialog.text += text
		yield(get_tree().create_timer(0.05), "timeout")
