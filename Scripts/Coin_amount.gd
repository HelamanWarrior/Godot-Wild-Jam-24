extends Label

func _process(_delta: float) -> void:
	text = " : " + str(Global.total_coins)
