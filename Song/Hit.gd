extends TestCube

export var meters_per_second = 1.0

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

func press(hit_time):
	print("Got hit with time offset ", hit_time - time)
	queue_free()

func start_lane():
	return lane

func end_lane():
	return lane