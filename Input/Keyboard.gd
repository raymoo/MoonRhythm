extends HBoxContainer

onready var buttons = get_children()
onready var button_count = buttons.size()

var touches_by_button = {}
var buttons_by_touch = {}

const button_up = preload("res://Input/button.png")
const button_down = preload("res://Input/button_down.png")

# Finger was pressed down
signal pressed(button_index)

# Finger moved between keys
signal moved(from_index, to_index)

# Finger was lifted
signal released(button_index)

func _ready():
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.SCREEN_DRAG:
		handle_drag(event)
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed:
		handle_press(event)
	if event.type == InputEvent.SCREEN_TOUCH and not event.pressed:
		handle_release(event)
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
		handle_click(event)
	if event.type == InputEvent.MOUSE_BUTTON and not event.pressed:
		handle_unclick(event)
	if event.type == InputEvent.MOUSE_MOTION:
		handle_mouse_drag(event)

func get_or_null(dict, key):
	if dict.has(key):
		return dict[key]
	else:
		return null

func remove_touch(touch_index, release=false):
	var button_index = get_or_null(buttons_by_touch, touch_index)
	if button_index != null:
		var button_touches = touches_by_button[button_index]
		button_touches.erase(touch_index)
		buttons_by_touch.erase(touch_index)
		if button_touches.size() == 0:
			touches_by_button.erase(button_index)
			buttons[button_index].set_texture(button_up)
		if release:
			emit_signal("released", button_index)

func place_touch(touch_index, button_index):
	var old_button_index = get_or_null(buttons_by_touch, touch_index)
	if old_button_index != button_index and button_index != null:
		remove_touch(touch_index)
		var button_touches = get_or_null(touches_by_button, button_index)
		if button_touches == null:
			button_touches = {}
			touches_by_button[button_index] = button_touches
		button_touches[touch_index] = true
		buttons_by_touch[touch_index] = button_index
		buttons[button_index].set_texture(button_down)
		if old_button_index == null:
			emit_signal("pressed", button_index)
		else:
			emit_signal("moved", old_button_index, button_index)

# 0 for the left edge, 1 for the right edge
func touch_position(x):
	var mystart = get_rect().pos.x
	var mywidth = get_rect().size.x
	var proportion_passed = float(x - mystart) / mywidth
	return proportion_passed

# Takes the event x
func button_index(x):
	var normalized_pos = touch_position(x)
	if normalized_pos < 0 or normalized_pos >= 1:
		return null
	else:
		return int(floor(normalized_pos * button_count))

func handle_drag(event):
	place_touch(event.index, button_index(event.x))

func handle_press(event):
	place_touch(event.index, button_index(event.x))

func handle_release(event):
	remove_touch(event.index)

var click_down = false
func handle_click(event):
	place_touch(button_count, button_index(event.x))
	click_down = true

func handle_unclick(event):
	remove_touch(button_count)
	click_down = false

func handle_mouse_drag(event):
	if click_down:
		handle_click(event)

func pressed_buttons():
	return touches_by_button.keys()