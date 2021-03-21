extends Node2D

export(int) var wander_range = 32
onready var start_pos = global_position
onready var target_pos = global_position
onready var timer = $Timer

func update_target_pos():
	var targer_vector = Vector2(rand_range(-wander_range,wander_range), rand_range(-wander_range,wander_range))
	target_pos = start_pos + targer_vector
	
func get_time_left():
	return timer.time_left

func start_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target_pos()
