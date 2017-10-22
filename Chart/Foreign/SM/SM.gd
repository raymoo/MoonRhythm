extends Reference

# Unimplemented tags
# - TITLE
# - SUBTITLE
# - ARTIST
# - TITLETRANSLIT
# - SUBTITLETRANSLIT
# - ARTISTTRANSLIT
# - GENRE
# - CREDIT
# - BANNER
# - BACKGROUND
# - LYRICSPATH
# - CDTITLE
# - MUSIC
# - SAMPLESTART
# - SAMPLELENGTH
# - DISPLAYBPM
# - SELECTABLE
# - BGCHANGES
# - FGCHANGES
# - MENUCOLOR

const Chart = preload("Chart.gd")

const pulses_per_beat = 192 / 4
const mpb_to_spp = 60.0 / pulses_per_beat
const default_bpm = 120
const default_mpb = 1.0 / 120
const default_spp = default_mpb * mpb_to_spp

var bpms = []
var stops = []
var charts = []
var offset = 0.0

func get_uncommented_line(file):
	var line = file.get_line()
	var comment_pos = line.find("//")
	return line.left(comment_pos - 1) if comment_pos >= 0 else line

func read_file(path):
	var file = File.new()
	if file.open(path, file.READ) != OK:
		return "Error reading file"
	while not file.eof_reached():
		var line = get_uncommented_line(file)
		var hashtag_pos = line.find("#")
		var eyes_pos = line.find(":", hashtag_pos)
		if hashtag_pos != -1 and eyes_pos != -1:
			var tag_begin = hashtag_pos + 1
			var tag_length = eyes_pos - tag_begin
			var tag = line.substr(tag_begin, tag_length)
			var tagline = line.substr(eyes_pos + 1, 9999)
			var error = handle_tag(tag, tagline, file)
			if error != null:
				return error

# Returns null or an error
func handle_tag(tag, tagline, file):
	if tag == "BPMS":
		return handle_bpms(tagline, file)
	elif tag == "STOPS":
		return handle_stops(tagline, file)
	elif tag == "OFFSET":
		offset = tagline.to_float()
		if offset == null:
			return "Bad Offset"
	elif tag == "NOTES":
		return handle_notes(file)
	else:
		var line = tagline
		while not line.ends_with(";"):
			line = get_uncommented_line(file)

const whitespaces = [" ", "\n", "\r", "\t"]
func unwhite(text):
	var result = text
	for whitespace in whitespaces:
		result = result.replace(whitespace, "")
	return result

func tag_text(tagline, file):
	var result = ""
	var line = unwhite(tagline)
	while not line.ends_with(";"):
		result = result + unwhite(line)
		line = get_uncommented_line(file)
	result = result + unwhite(line.left(line.length() - 1))
	return result

func make_bpm(beat, bpm):
	return { "pulse" : round(beat * pulses_per_beat), "bpm" : bpm }

func handle_bpms(tagline, file):
	var text = tag_text(tagline, file)
	var pairs = text.split(",")
	for pair in pairs:
		var values = pair.split_floats("=", false)
		if values == null or values.size() != 2:
			return "Bad BPM: " + pair
		else:
			bpms.push_back(make_bpm(values[0], values[1]))

func make_stop(beat, duration):
	return { "pulse" : round(beat * pulses_per_beat), "duration" : duration }

func handle_stops(tagline, file):
	var text = tag_text(tagline, file)
	if text != "":
		var pairs = text.split(",")
		for pair in pairs:
			var values = pair.split_floats("=", false)
			if values == null or values.size() != 2:
				return "Bad Stop: " + pair
			else:
				stops.push_back(make_stop(values[0], values[1]))

func handle_notes(file):
	var chart = Chart.new()
	chart.read_file(file)
	charts.push_back(chart)