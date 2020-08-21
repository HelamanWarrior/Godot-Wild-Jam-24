extends Node

var sound_script: Script = load("res://Scripts/Sound.gd")

var sound_mute: bool = false

func play_sound(sound):
	if sound_mute == false:
		var sound_fx = AudioStreamPlayer.new()
		add_child(sound_fx)
		sound_fx.stream = load(sound)
		sound_fx.pitch_scale = rand_range(0.8, 1.2)
		sound_fx.volume_db = -5
		sound_fx.set_script(sound_script)
		sound_fx.connect("finished", sound_fx, "finished")
		sound_fx.pause_mode = Node.PAUSE_MODE_PROCESS
		sound_fx.play()
	
