extends FileDialog

const SM = preload("res://Song/Chart/Foreign/SM/SM.gd")

func _ready():
	set_mode(MODE_OPEN_FILE)
	set_access(ACCESS_FILESYSTEM)
	connect("file_selected", self, "on_file_chosen")
	get_cancel().connect("button_up", self, "on_cancel")
	popup()

func on_file_chosen(path):
	var sm = SM.new()
	var error = sm.read_file(path)
	if error != null:
		print("Error: " + error)
	else:
		for bpm in sm.bpms:
			print("Beat: ", bpm.beat, " BPM: ", bpm.bpm)

func on_cancel():
	print("Cancelled")