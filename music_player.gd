extends CanvasLayer


onready var intro_player = $IntroSong
onready var street_player = $StreetSong
onready var volume_bar = $Control/VolumeBar

var minimum_db = -42
var maximum_db = 0


func _ready():
	volume_bar.value = minimum_db + 0.5 * (maximum_db - minimum_db)
	AudioServer.set_bus_volume_db(0, volume_bar.value)
	play_intro_song()


func _input(event):
	if event.is_action_pressed("volume_up"):
		volume_bar.value += 0.1 * (maximum_db - minimum_db)
		AudioServer.set_bus_volume_db(0, volume_bar.value)
		if volume_bar.value > minimum_db:
			AudioServer.set_bus_mute(0, false)
	elif event.is_action_pressed("volume_down"):
		volume_bar.value -= 0.1 * (maximum_db - minimum_db)
		AudioServer.set_bus_volume_db(0, volume_bar.value)
		if volume_bar.value <= minimum_db:
			AudioServer.set_bus_mute(0, true)


func play_intro_song():
	intro_player.play()
	street_player.stop()


func play_street_song():
	street_player.play()
	intro_player.stop()


func stop():
	intro_player.stop()
	street_player.stop()
