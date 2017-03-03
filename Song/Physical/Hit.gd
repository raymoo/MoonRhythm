extends TestCube

const happy = preload("res://Song/Physical/Happy.png")
const sad = preload("res://Song/Physical/Sad.png")
const scoreview = preload("res://Song/Physical/ScorePicture.tscn")

export var meters_per_second = 1.0
onready var parent = get_parent()


var active = true

export var lane = 0
export var time = 0.0

func _ready():
	var x = lane * 0.125 - 0.5 + 0.0625
	var translation = get_translation()
	translation.x = x
	set_translation(translation)

func update(display_time):
	var tminus = display_time - time
	var translation = get_translation()
	translation.z = tminus * meters_per_second
	set_translation(translation)
	if tminus > 0.5:
		var pos = lane * 0.125 - 0.5 + 0.625
		var pic = scoreview.instance()
		pic.set_texture(sad)
		pic.x = pos
		parent.add_child(pic)
		queue_free()
		active = false

func press(hit_time):
	var pos = lane * 0.125 - 0.5 + 0.625
	if abs(hit_time - time) < 0.25 and active:
		var pic = scoreview.instance()
		pic.set_texture(happy)
		pic.x = pos
		parent.add_child(pic)
		queue_free()
		active = false
	elif abs(hit_time - time) < 0.5 and active:
		var pic = scoreview.instance()
		pic.set_texture(sad)
		pic.x = pos
		parent.add_child(pic)
		queue_free()
		active = false

func start_lane():
	return lane

func end_lane():
	return lane