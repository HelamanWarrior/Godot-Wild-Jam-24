extends Node

var player: KinematicBody2D = null
var player_role: String = "father"
var instance_player_from_tent: bool = false

var going_to_bed: Control = null

var lost_child_1_found: bool = false
var lost_child_2_found: bool = false
var bought_dimensional_portal: bool = false

var total_coins: int = 0

var camera: Camera2D = null
var time_cycle_color: CanvasModulate = null
var dialog_box: ColorRect = null
var transition: ColorRect = null

var is_game_over: bool = false
var is_role_select: bool = true

var raw_time_hours: int = 6
var raw_time_minutes: int = 0

var time_hours: int = 6
var time_minutes: int = 0
var is_afternoon: bool = false

var time_scale: float = 1

onready var time_pass_timer: Timer = Timer.new()

func _ready() -> void:
	add_child(time_pass_timer)
	time_pass_timer.connect("timeout", self, "_on_Time_pass_timer_timeout")
	time_pass_timer.wait_time = 0.1 * time_scale
	time_pass_timer.start()

func _process(_delta: float) -> void:
	if lost_child_1_found and lost_child_2_found:
		get_tree().change_scene("res://Scenes/Found_all_children.tscn")

func instance_node(node: Object, parent: Object):
	var node_instance: Object = node.instance()
	parent.call_deferred("add_child", node_instance)
	return node_instance

func instance_node_at_location(node: Object, parent: Object, location: Vector2):
	var node_instance: Object = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance

func _on_Time_pass_timer_timeout() -> void:
	if not is_role_select:
		if time_minutes < 59:
			time_minutes += 1
			raw_time_minutes += 1
			
			if Global.time_cycle_color != null and not is_game_over and not is_role_select:
				Global.time_cycle_color.update_colors()
		else:
			time_hours += 1
			raw_time_hours += 1
			time_minutes = 0
		
		if time_hours > 12:
			time_hours = 1
		
		if raw_time_hours >= 22:
			if Global.going_to_bed != null:
				if not Global.going_to_bed.started and not Global.is_role_select:
					Global.going_to_bed.start()
		
		if time_hours == 12 and time_minutes == 0:
			is_afternoon = !is_afternoon

func reset_time():
	Global.raw_time_hours = 6
	Global.time_hours = 6
	Global.time_minutes = 0
	Global.raw_time_minutes = 0
	Global.is_afternoon = false

func reset():
	Global.total_coins = 0
	Global.lost_child_1_found = false
	Global.lost_child_2_found = false
	reset_time()

func freeze_node(node, freeze):
	node.set_process(!freeze)
	node.set_physics_process(!freeze)
	node.set_process_input(!freeze)
	node.set_process_internal(!freeze)
	node.set_process_unhandled_input(!freeze)
	node.set_process_unhandled_key_input(!freeze)
