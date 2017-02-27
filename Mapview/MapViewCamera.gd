
extends Control

onready var camera = get_node("Viewport/Camera")
onready var viewport = get_node("Viewport")

func _ready():
	camera.update_size()
	viewport.connect("size_changed", self, "_handle_resize")

func _handle_resize():
	camera.update_size()
