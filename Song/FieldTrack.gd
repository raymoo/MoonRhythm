extends Control

const happy_image = preload("res://Song/Physical/Happy.png")
const sad_image = preload("res://Song/Physical/Sad.png")

const ScorePicture = preload("res://Song/Physical/ScorePicture.tscn")

var time = 0

# After a lane hits an object, it is blocked for 2 frames
var new_blocked_lane_ranges = []
var old_blocked_lane_ranges = []

func _ready():
	set_process(true)
	set_fixed_process(true)

func _fixed_process(delta):
	old_blocked_lane_ranges = new_blocked_lane_ranges
	new_blocked_lane_ranges = []

func _process(delta):
	time += delta
	get_tree().call_group(0, "field_update", "update", self, time)

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
			var handled = element.press(self, time)
			if handled:
				break

func handle_move(from, to):
	handle_press(to)
