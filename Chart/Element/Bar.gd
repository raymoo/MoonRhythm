extends Reference

const PhysicalBar = preload("res://Player/Elements/Bar.tscn")

var time_ms
var start_lane
var end_lane

func _init(time_ms, start_lane, end_lane):
	self.time_ms = time_ms
	self.start_lane = start_lane
	self.end_lane = end_lane

func get_time():
	return time_ms / 1000.0

func make_physical(scroll_pos):
	var manifestation = PhysicalBar.instance()
	manifestation._init(start_lane, end_lane, time_ms / 1000.0, scroll_pos)
	return manifestation