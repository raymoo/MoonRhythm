extends Spatial

var time = 0

func _ready():
	set_process(true)

func _process(delta):
	time += delta
	var elements = get_children()
	for element in elements:
		element.update(time)

func is_affected(button_index, element):
	return button_index >= element.start_lane() and button_index <= element.end_lane()

func handle_press(button_index):
	var elements = get_children()
	for element in elements:
		if is_affected(button_index, element):
			element.press(time)