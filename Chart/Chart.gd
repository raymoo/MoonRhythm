extends Reference

const ScrollSpeedChange = preload("res://Chart/ScrollSpeedChange.gd")
const Bar = preload("res://Chart/Element/Bar.gd")

# Notes etc.
var elements = []
var scroll_speed_changes = []

static func make_randoms(count, interval, offset):
	var rand_elems = []
	var time = 0
	var interval_ms = round(interval * 1000)
	var offset_ms = round(offset * 1000)
	for i in range(count):
		var size = 2 * (randi()%2) + 2
		var start_lane = randi() % (9 - size)
		var end_lane = start_lane + size - 1
		rand_elems.push_back(Bar.new(i * interval_ms + offset_ms, start_lane, end_lane))
	var chart = new()
	chart.elements = rand_elems
	
	return chart

static func make_overlap_case(offset):
	var offset_ms = offset * 1000
	var elems = [Bar.new(offset_ms, 0, 3), Bar.new(offset_ms + 200, 0, 4)]
	
	var chart = new()
	chart.elements = elems
	return chart

const SM_MEASURE = preload("res://Chart/Foreign/SM/Measure.gd")

const EVENT_NOTE_LINE = 0
const EVENT_BPM = 1
const EVENT_STOP = 2

static func cmp_sm_event(ev1, ev2):
	if ev1[1] < ev2[1]:
		return true
	elif ev2[1] < ev1[1]:
		return false
	else:
		return ev1[0] < ev2[0]

# Assumes 4k
static func from_sm(sm, sm_chart):
	var chart = new()
	var events = []
	var measures = sm_chart.measures
	var bpms = sm.bpms
	var stops = sm.stops
	
	var pulse = 0
	for measure in measures:
		var denominator = measure.get_denominator()
		var pulses_per_line = 192 / denominator
		for note_line in measure.note_lines:
			events.push_back([EVENT_NOTE_LINE, pulse, note_line])
			pulse += pulses_per_line
	for bpm in bpms:
		events.push_back([EVENT_BPM, bpm.pulse, bpm])
	for stop in stops:
		events.push_back([EVENT_STOP, stop.pulse, stop])
	events.sort_custom(new(), "cmp_sm_event")
	
	var section_start_pulse = 0
	var section_start_time = sm.offset
	var section_spp = sm.default_spp
	var speed_percent = 100
	for event in events:
		var type = event[0]
		var pulse = event[1]
		var data = event[2]
		var pulse_diff = pulse - section_start_pulse
		var time = section_start_time + pulse_diff * section_spp
		var time_ms = round(1000 * time)
		if type == EVENT_NOTE_LINE:
			for i in range(data.size()):
				if data[i] == SM_MEASURE.NOTE_NORMAL:
					var start_lane = i * 2
					var end_lane = start_lane + 1
					chart.elements.push_back(Bar.new(time_ms, start_lane, end_lane))
		elif type == EVENT_BPM:
			speed_percent = 100 * data.bpm / 120
			var change = ScrollSpeedChange.new(time_ms, speed_percent)
			chart.scroll_speed_changes.push_back(change)
			section_start_pulse = pulse
			section_start_time = time
			section_spp = (1.0 / data.bpm) * sm.mpb_to_spp
		elif type == EVENT_STOP:
			var end_time = time + data.duration
			var end_time_ms = round(1000 * end_time)
			var change = ScrollSpeedChange.new(time_ms, 0)
			chart.scroll_speed_changes.push_back(change)
			var end_change = ScrollSpeedChange.new(end_time_ms, speed_percent)
			chart.scroll_speed_changes.push_back(end_change)
			section_start_pulse = pulse
			section_start_time = time + data.duration
			section_spp = section_spp
	return chart
