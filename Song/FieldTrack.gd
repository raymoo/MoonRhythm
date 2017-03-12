extends Control

const happy_image = preload("res://Song/Physical/Happy.png")
const sad_image = preload("res://Song/Physical/Sad.png")

const ScorePicture = preload("res://Song/Physical/ScorePicture.tscn")

var time = 0.0
var scroll_pos = 0.0
export var scroll_speed = 1.0

# After a lane hits an object, it is blocked for 2 frames (unimplemented)
var new_blocked_lane_ranges = []
var old_blocked_lane_ranges = []

func _ready():
	set_process(true)
	set_fixed_process(true)
	generate_test_scale(6, 2)

func _fixed_process(delta):
	time += delta
	scroll_pos += scroll_speed * delta
	old_blocked_lane_ranges = new_blocked_lane_ranges
	new_blocked_lane_ranges = []
	get_tree().call_group(0, "field_update", "update", self, scroll_pos, time)

func _process(delta):
	get_tree().call_group(0, "field_update_visual", "update_visual", self, scroll_pos, time)

func show_score_object(is_good, lane_pos):
	var pos = lane_pos * 0.125
	var image = happy_image if is_good else sad_image
	var object = ScorePicture.instance()
	object.set_texture(image)
	object.x = pos
	add_child(object)
	

func is_affected(button_index, element):
	return button_index >= element.get_start_lane() and button_index <= element.get_end_lane()

func cmp_element(elem1, elem2):
	return elem1.get_time() < elem2.get_time()

func handle_press(button_index):
	var elements = get_tree().get_nodes_in_group("field_press")
	elements.sort_custom(self, "cmp_element")
	for element in elements:
		if is_affected(button_index, element):
			var handled = element.press(self, scroll_pos, time)
			if handled:
				break

func handle_move(from, to):
	handle_press(to)

const Bar = preload("res://Song/Physical/Bar.tscn")

func generate_test_scale(flight_count, offset):
	var cur_time = offset
	for i in range(flight_count):
		for i in range(7):
			var b = Bar.instance()
			b._init(i, i, cur_time, cur_time * scroll_speed)
			cur_time += 0.125
			add_child(b)
		for i in range(7):
			var actual_i = 7 - i
			var b = Bar.instance()
			b._init(actual_i, actual_i, cur_time, cur_time * scroll_speed)
			cur_time += 0.125
			add_child(b)
			