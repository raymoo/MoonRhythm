extends Panel

func handle_button_press():
	var file_path = get_node("LineEdit").get_text()
	var audio_manager = get_node("AudioManager")
	audio_manager.load_song(file_path)
	audio_manager.play()
