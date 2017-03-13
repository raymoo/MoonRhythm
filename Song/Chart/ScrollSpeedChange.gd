extends Reference

var time_ms = 0
var speed_percent = 100

func _init(time_ms, speed_percent):
	self.time_ms = time_ms
	self.speed_percent = speed_percent

func get_time():
	return time_ms / 100.0

func get_speed_multiplier():
	return speed_percent / 100.0