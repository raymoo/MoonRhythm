extends TestCube

const good_threshold = 0.2
const bad_threshold = 0.5

const MIN_X = -0.5
const LANE_COUNT = 8
const LANE_INTERVAL = 1.0 / LANE_COUNT

export var start_lane = 0
export var end_lane = 0
export var time = 0.0
export var speed = 1.0

onready var center_lane = (end_lane + 1 + start_lane) / 2.0
var active = true

func _init(start=0, end=0, note_time=0.0):
	start_lane = start
	end_lane = end
	time = note_time

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

func die():
	active == false
	queue_free()

func get_start_lane():
	return start_lane

func get_end_lane():
	return end_lane

func get_time():
	return time

func update(track, display_time):
	if not active: return
	var tminus = display_time - time
	var translation = get_translation()
	translation.z = tminus * speed
	set_translation(translation)
	
	if tminus > bad_threshold:
		track.show_score_object(false, center_lane)
		die()

func press(track, press_time):
	var diff = abs(press_time - time)
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