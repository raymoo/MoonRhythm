extends HBoxContainer

onready var buttons = get_children()
onready var touches = {}

onready var button_count = buttons.size()

const button_up = preload("res://Keyboard/button.png")
const button_down = preload("res://Keyboard/button_down.png")

signal press(position)
signal release(position)

func _ready():
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.SCREEN_DRAG:
		handle_drag(event)
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed:
		handle_press(event)
	if event.type == InputEvent.SCREEN_TOUCH and not event.pressed:
		handle_release(event)

# -0.5 is the left edge and 0.5 is the right edge.
func touch_position(x):
	var mystart = get_rect().pos.x
	var mywidth = get_rect().size.x
	var proportion_passed = float(x - mystart) / mywidth
	return proportion_passed - 1

# Takes the position from the above function
func button_index(position):
	var normalized_pos = position + 1
	if normalized_pos < 0 or normalized_pos >= 1:
		return null
	else:
		return int(floor(normalized_pos * button_count))

func update_buttons():
	var buttons_pressed = {}
	for p in touches.values():
		var index = button_index(p)
		if index != null:
			buttons_pressed[index] = true
	for i in range(button_count):
		if buttons_pressed.has(i):
			buttons[i].set_texture(button_down)
		else:
			buttons[i].set_texture(button_up)

func handle_drag(event):
	touches[event.index] = touch_position(event.x)
	update_buttons()

func handle_press(event):
	touches[event.index] = touch_position(event.x)
	update_buttons()

func handle_release(event):
	touches.erase(event.index)
	update_buttons()

func touched_positions():
	return touches.values()
