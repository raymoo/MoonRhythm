
extends Camera

const fovy = PI/2
const plane_width = 1
const plane_side = plane_width * 0.5

func _ready():
	pass

func update_size():
	var screen = get_viewport().get_visible_rect()
	var aspect = screen.size.x / screen.size.y
	var fovx = 2*atan(tan(fovy/2) * aspect)
	
	var dist_to_edge_plane = plane_side / tan(fovx/2)
	var dist_to_edge = dist_to_edge_plane / cos(fovy/2)
	
	set_translation(Vector3(0, dist_to_edge, 0))
	set_perspective(rad2deg(fovy), dist_to_edge_plane/2, 1000*sqrt(2))
	set_rotation(Vector3(fovy/2 - PI/2, 0, 0))
	