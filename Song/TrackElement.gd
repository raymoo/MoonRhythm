extends Reference

var start_beat
var snap_denominator # Used for editor, in fractions of a beat

# Adds the element to a playing field
func add_to_field(field, time):
	print("add_to_field: default track element")