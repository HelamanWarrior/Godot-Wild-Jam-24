extends Sprite

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var collision: CollisionShape2D = $Hitbox/CollisionShape2D

var collected: bool = false

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player") and not collected:
		Sound_manager.play_sound("res://Sounds/Coin_sound.wav")
		Global.total_coins += 1
		animation_player.play("Coin collect")
		collected = true

func destroy() -> void:
	queue_free()
