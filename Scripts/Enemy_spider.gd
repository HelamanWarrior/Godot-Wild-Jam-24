extends "res://Scripts/Enemy_core.gd"

export(int) var end_location_x

var current_location = locations.START

onready var start_location = global_position

enum locations {
	START,
	END
}

func _ready() -> void:
	end_location_x += global_position.x

func _process(_delta: float) -> void:
	movement()

func movement() -> void:
	if not is_knocked_back:
		if current_location == locations.START:
			velocity.x = 1
			sprite.flip_h = false
			
			if global_position.x > end_location_x:
				current_location = locations.END
		elif current_location == locations.END:
			velocity.x = -1
			sprite.flip_h = true
			
			if global_position < start_location.x:
				current_location = locations.START


