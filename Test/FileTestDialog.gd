extends FileDialog

func _ready():
	set_mode(MODE_OPEN_FILE)
	set_access(ACCESS_FILESYSTEM)
	set_current_dir("user://")
	get_cancel().connect("button_up", self, "on_cancel")
	popup()

func on_cancel():
	print("Cancelled")