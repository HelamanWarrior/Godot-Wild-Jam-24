extends TextureRect

export(Texture) var highlight_texture

onready var default_texture: Texture = texture

var is_mouse_hovering: bool = false

onready var button: TextureButton = $TextureButton

func _ready() -> void:
	button.connect("mouse_entered", self, "_mouse_entered")
	button.connect("mouse_exited", self, "_mouse_exited")
	button.connect("pressed", self, "_pressed")
	texture = default_texture

func _process(_delta: float) -> void:
	if visible: 
		if is_mouse_hovering and texture != highlight_texture:
			texture = highlight_texture
		elif not is_mouse_hovering and texture != default_texture:
			texture = default_texture

func _pressed() -> void:
	Sound_manager.play_sound("res://Sounds/Select_role.wav")
	Global.player_role = name
	Global.is_role_select = false
	get_tree().paused = false
	
	if Global.player != null:
		Global.player.global_position = Vector2(145, 105)
		Global.player.update_role()

func _mouse_entered() -> void:
	is_mouse_hovering = true

func _mouse_exited() -> void:
	is_mouse_hovering = false

