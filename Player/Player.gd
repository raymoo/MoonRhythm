extends Control

const happy_image = preload("res://Player/Judgment/Happy.png")
const sad_image = preload("res://Player/Judgment/Sad.png")

const Chart = preload("res://Chart/Chart.gd")
const ElementBuffer = preload("res://Player/ElementBuffer.gd")
const ScorePicture = preload("res://Player/Judgment/ScorePicture.tscn")

var time = 0.0
export var speed_multiplier = 1.0
var element_buffer

# After a lane hits an object, it is blocked for 2 frames
var new_blocked_lane_ranges = []
var old_blocked_lane_ranges = []

func _ready():
	set_process(true)
	set_fixed_process(true)
	if element_buffer == null:
		var random_chart = Chart.make_randoms(100, 0.25, 2)
		element_buffer = ElementBuffer.new(random_chart, speed_multiplier)

func load_chart(chart):
	time = 0.0
	element_buffer = ElementBuffer.new(chart, speed_multiplier)

func _fixed_process(delta):
	old_blocked_lane_ranges = new_blocked_lane_ranges
	new_blocked_lane_ranges = []
	time += delta
	var scroll_pos = element_buffer.time_to_scroll_pos(time)
	element_buffer.add_new_elements_to(self, scroll_pos + 5)
	get_tree().call_group(0, "field_update", "update", self, scroll_pos, time)

func _process(delta):
	var scroll_pos = element_buffer.time_to_scroll_pos(time)
	get_tree().call_group(0, "field_update_visual", "update_visual", self, scroll_pos, time)

func show_score_object(is_good, lane_pos):
	var pos = lane_pos * 0.125
	var image = happy_image if is_good else sad_image
	var object = ScorePicture.instance()
	object.set_texture(image)
	object.x = pos
	add_child(object)
	

func is_affected(button_index, element):
	return button_index >= element.get_start_lane() and button_index <= element.get_end_lane() and valid_hit(button_index, element.get_time())

func cmp_element(elem1, elem2):
	return elem1.get_time() < elem2.get_time()

func handle_press(button_index):
	var scroll_pos = element_buffer.time_to_scroll_pos(time)
	var elements = get_tree().get_nodes_in_group("field_press")
	elements.sort_custom(self, "cmp_element")
	for element in elements:
		if is_affected(button_index, element):
			var handled = element.press(self, scroll_pos, time)
			if handled:
				for button_index in range(element.get_start_lane(), element.get_end_lane() + 1):
					var entry = {
						"start_lane" : element.get_start_lane(),
						"end_lane" : element.get_end_lane(),
						"time" : element.get_time()
					}
					new_blocked_lane_ranges.push_back(entry)
				break

func handle_move(from, to):
	handle_press(to)

func valid_hit(button_index, element_time):
	for r in new_blocked_lane_ranges:
		if button_index >= r.start_lane and button_index <= r.end_lane and element_time > r.time:
			return false
	for r in old_blocked_lane_ranges:
		if button_index >= r.start_lane and button_index <= r.end_lane and element_time > r.time:
			return false
	return true