extends Reference

# Physical elements, sorted in order of ascending scroll position
var elements = []
# Next new element
var elem_index = 0
# Scrolling speed changes in order of time
var scroll_speed_changes = []
# Player's custom speed multiplier
var player_multiplier = 1.0

func less_scroll_pos(elem1, elem2):
	return elem1.get_scroll_pos() < elem2.get_scroll_pos()

# Input is a float in seconds
func time_to_scroll_pos(time):
	var last_pos = 0.0
	var last_speed = player_multiplier
	var last_time = 0.0
	for change in scroll_speed_changes:
		var change_time = change.get_time()
		var change_speed = change.get_speed_multiplier() * player_multiplier
		if change_time >= time:
			return last_pos + (time - last_time) * last_speed
		else:
			last_pos = last_pos + (change_time - last_time) * last_speed
			last_speed = change_speed
			last_time = change_time
	return last_pos + (time - last_time) * last_speed

func _init(chart, player_multiplier=1.0):
	scroll_speed_changes = chart.scroll_speed_changes
	self.player_multiplier = player_multiplier
	for elem in chart.elements:
		var scroll_pos = time_to_scroll_pos(elem.get_time())
		elements.push_back(elem.make_physical(scroll_pos))
	elements.sort_custom(self, "less_scroll_pos")

func add_new_elements_to(track, scroll_pos):
	var new_elements = []
	while elem_index < elements.size() and elements[elem_index].get_scroll_pos() <= scroll_pos:
		var new_element = elements[elem_index]
		elem_index += 1
		track.add_child(new_element)