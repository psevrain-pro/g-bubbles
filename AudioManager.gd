extends Node

var num_players = 20
var music_player
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = bus
	
	#play_music("res://sons/Kubbi-Ember-04Cascade.mp3", -20.0)


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)


func play(sound_path):
	queue.append(sound_path)

func play_music(sound_path, db):
	music_player.stream = load (sound_path)
	music_player.play()
	music_player.set_volume_db(db)

func stop_music():
	music_player.stop()

func is_playing_music() -> bool :
	return music_player.is_playing()

func play_gui():
	play("res://sounds/pouic.mp3")


func _process(delta):
	# Play a queued sound if any players are available.
	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()



