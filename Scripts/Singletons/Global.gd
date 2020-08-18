extends Node

var player: KinematicBody2D = null
var camera: Camera2D = null
var time_cycle_color: CanvasModulate = null

var raw_time_hours: int = 6
var time_hours: int = 6
var time_minutes: int = 0
var is_afternoon: bool = false

var time_scale: float = 0.35

onready var time_pass_timer: Timer = Timer.new()

func _ready() -> void:
	add_child(time_pass_timer)
	time_pass_timer.connect("timeout", self, "_on_Time_pass_timer_timeout")
	time_pass_timer.wait_time = 1 * time_scale
	time_pass_timer.start()

func instance_node(node: Object, parent: Object):
	var node_instance: Object = node.instance()
	parent.call_deferred("add_child", node_instance)
	return node_instance

func instance_node_at_location(node: Object, parent: Object, location: Vector2):
	var node_instance: Object = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance

func _on_Time_pass_timer_timeout() -> void:
	if time_minutes < 59:
		time_minutes += 1
		
		if Global.time_cycle_color != null:
			Global.time_cycle_color.update_colors()
	else:
		time_hours += 1
		raw_time_hours += 1
		time_minutes = 0
	
	if time_hours > 12:
		time_hours = 1
	
	if time_hours == 12 and time_minutes == 0:
		is_afternoon = !is_afternoon

