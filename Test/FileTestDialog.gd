extends FileDialog

func _ready():
	set_mode(MODE_OPEN_FILE)
	set_access(ACCESS_FILESYSTEM)
	if OS.get_name() == "Android":
		set_current_dir("/sdcard")
	else:
		set_current_dir("user://")
	get_cancel().connect("button_up", self, "on_cancel")
	popup()

func on_cancel():
	print("Cancelled")