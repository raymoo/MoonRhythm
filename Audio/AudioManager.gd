extends Node

var stream_player

var time
var last_known_playback_pos

func initialize():
	time = 0.0
	last_known_playback_pos = 0.0

func _ready():
	initialize()
	stream_player = get_node("StreamPlayer")
	set_fixed_process(true)

func _fixed_process(delta):
	if stream_player.is_playing():
		time += delta
		var current_playback_pos = stream_player.get_pos()
		if current_playback_pos != last_known_playback_pos:
			last_known_playback_pos = current_playback_pos
			time = (time + current_playback_pos) / 2
			print("Playback time error: ", time - current_playback_pos)

func load_song(song_path):
	stream_player.stop()
	initialize()
	var new_stream = load(song_path)
	stream_player.set_stream(new_stream)

func play():
	stream_player.play()

func get_time():
	return time