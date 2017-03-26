extends Reference

const Measure = preload("Measure.gd")

var type
var description
var difficulty
var level
var groove_values = []

var measures = []

func get_uncommented_line(file):
	var line = file.get_line()
	var comment_pos = line.find("//")
	return line.left(comment_pos - 1) if comment_pos >= 0 else line

func get_uncol_line(file):
	var line = get_uncommented_line(file)
	var stripped = line.strip_edges()
	return stripped.left(stripped.length() - 1)

func read_file(file):
	var type_line = get_uncol_line(file)
	var description_line = get_uncol_line(file)
	var difficulty_line = get_uncol_line(file)
	var level_line = get_uncol_line(file)
	var groove_line = get_uncol_line(file)

	type = type_line
	description = description_line
	difficulty = difficulty_line
	level = level_line.to_int()
	if level == null:
		return "Bad level"
	groove_values = groove_line.split_floats(",")
	measures = []
	
	var line = get_uncommented_line(file).strip_edges()
	var accumulated_lines = []
	while line != ";":
		if line == ",":
			var measure = Measure.new()
			var error = measure.read_lines(accumulated_lines)
			accumulated_lines = []
			if error != null:
				return error
			measures.push_back(measure)
		elif(line.length() > 0):
			accumulated_lines.push_back(line)
		line = get_uncommented_line(file).strip_edges()
	var measure = Measure.new()
	var error = measure.read_lines(accumulated_lines)
	if error != null:
		return error
	measures.push_back(measure)