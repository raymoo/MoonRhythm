extends Sprite

export var x = 0
var time = 0

func _ready():
	set_process(true)
	var control = get_parent()
	var size = control.get_size()
	set_pos(Vector2(x * size.x, size.y / 2))

func _process(delta):
	time += delta
	if time > 0.5:
		set_hidden(true)
		queue_free()
	var pos = get_pos()
	pos.y -= delta * 100
	set_pos(pos)
