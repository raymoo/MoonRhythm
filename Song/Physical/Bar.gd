extends TestCube

const good_threshold = 0.1
const bad_threshold = 0.2

const MIN_X = -0.5
const LANE_COUNT = 8
const LANE_INTERVAL = 1.0 / LANE_COUNT

var start_lane = 0
var end_lane = 0
var my_scroll_pos = 0.0
var my_time = 0.0

onready var center_lane = (end_lane + 1 + start_lane) / 2.0
var active = true

func _init(start=0, end=0, note_time=0.0, note_scroll_pos=0.0):
	start_lane = start
	end_lane = end
	my_time = note_time
	my_scroll_pos = note_scroll_pos

func _ready():
	var x = center_lane * LANE_INTERVAL + MIN_X
	var width = (end_lane + 1 - start_lane)
	var x_scale = width * LANE_INTERVAL
	var translation = get_translation()
	translation.x = x
	set_translation(translation)
	var scale = get_scale()
	scale.x = x_scale / 2.0 - 0.005
	set_scale(scale)
	add_to_group("field_update")
	add_to_group("field_press")

func die():
	active == false
	queue_free()

func get_start_lane():
	return start_lane

func get_end_lane():
	return end_lane

func get_time():
	return my_time

func get_scroll_pos():
	return my_scroll_pos

func update(track, scroll_pos, time):
	if not active: return
	var tminus = time - my_time
	var scroll_minus = scroll_pos - my_scroll_pos
	var translation = get_translation()
	translation.z = scroll_minus
	set_translation(translation)
	
	if tminus > bad_threshold:
		track.show_score_object(false, center_lane)
		die()

func press(track, scroll_pos, time):
	var diff = abs(time - my_time)
	if diff < good_threshold:
		track.show_score_object(true, center_lane)
		die()
		return true
	elif diff < bad_threshold:
		track.show_score_object(false, center_lane)
		die()
		return true
	else:
		return false