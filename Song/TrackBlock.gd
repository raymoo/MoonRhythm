extends Reference

var bpm
var beats_in_measure # Used for drawing lines
var beat_count
var elements # List of map elements
var measure_offset # How many beats forward the first measure starts

func _init(bpm, beat_count, beats_in_measure, elements, measure_offset=0):
	self.bpm = bpm
	self.beat_count = beat_count
	self.beats_in_measure = beats_in_measure
	self.elements = elements
	self.measure_offset = measure_offset