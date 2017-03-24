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
# - OFFSET
# - STOPS
# - SAMPLESTART
# - SAMPLELENGTH
# - DISPLAYBPM
# - SELECTABLE
# - BGCHANGES
# - FGCHANGES
# - NOTES
# - MENUCOLOR

const BPM = preload("BPM.gd")

var bpms = []

func read_file(path):
	var file = File.new()
	if file.open(path, file.READ) != OK:
		return "Error reading file"
	while not file.eof_reached():
		var line = file.get_line()
		if not line.begins_with("//"):
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
		return handle_bpms(tagline)
	else:
		var line = tagline
		while not line.match("*;"):
			line = file.get_line()

func handle_bpms(text):
	var without_semicolon = text.substr(0, text.length() - 1)
	var pairs = without_semicolon.split(",")
	for pair in pairs:
		var values = pair.split_floats("=", false)
		if values == null or values.size() != 2:
			return "Bad BPM: " + pair
		else:
			bpms.push_back(BPM.new(values[0], values[1]))