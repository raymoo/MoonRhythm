extends Reference

const ScrollSpeedChange = preload("res://Song/Chart/ScrollSpeedChange.gd")
const Bar = preload("res://Song/Chart/Element/Bar.gd")

# Notes etc.
var elements = []
var scroll_speed_changes = []

static func make_randoms(count, interval, offset):
	var rand_elems = []
	var time = 0
	var interval_ms = round(interval * 100)
	var offset_ms = round(offset * 100)
	for i in range(count):
		var size = 2
		var start_lane = randi() % (9 - size)
		var end_lane = start_lane + size - 1
		rand_elems.push_back(Bar.new(i * interval_ms + offset_ms, start_lane, end_lane))
	var chart = new()
	chart.elements = rand_elems
	
	return chart