extends Reference

const NOTE_NONE = 0
const NOTE_NORMAL = 1
const NOTE_HOLD = 2
const NOTE_TAIL = 3
const NOTE_ROLL = 4
const NOTE_MINE = 5
const NOTE_KEYSOUND = 6
const NOTE_LIFT = 7
const NOTE_FAKE = 8

var ORD_NONE = "0".ord_at(0)
var ORD_NORMAL = "1".ord_at(0)
var ORD_HOLD = "2".ord_at(0)
var ORD_TAIL = "3".ord_at(0)
var ORD_ROLL = "4".ord_at(0)
var ORD_MINE = "M".ord_at(0)
var ORD_KEYSOUND = "K".ord_at(0)
var ORD_LIFT = "L".ord_at(0)
var ORD_FAKE = "F".ord_at(0)

var notemap = {
	ORD_NONE : NOTE_NONE,
	ORD_NORMAL : NOTE_NORMAL,
	ORD_HOLD : NOTE_HOLD,
	ORD_TAIL : NOTE_TAIL,
	ORD_ROLL : NOTE_ROLL,
	ORD_MINE : NOTE_MINE,
	ORD_KEYSOUND : NOTE_KEYSOUND,
	ORD_LIFT : NOTE_LIFT,
	ORD_FAKE : NOTE_FAKE
}

var note_lines = []

func read_lines(text_lines):
	note_lines = []
	for text_line in text_lines:
		var note_line = []
		for i in range(text_line.length()):
			var ord = text_line.ord_at(i)
			if notemap.has(ord):
				note_line.push_back(notemap[ord])
			else:
				note_line.push_back(NOTE_NONE)
				print("Unknown note type: ", text_line.substr(i, 1))
		note_lines.push_back(note_line)

func get_denominator():
	return note_lines.size()