extends Node2D


# Emitted when the camera pans back to the transformed party house.
signal house_transformed


onready var camera_player = $CameraPlayer
onready var house_player = $Outside/AnimationPlayer
onready var speaker_player = $Furniture/Speaker/SpeakerPlayer


func _ready():
	# Get ending state from global, if true, then load ending scene.
	if Global.is_ending:
		add_child(preload("res://ending.tscn").instance())
		$Backwall.color = Color(0.71, 0.67, 0.71, 1.0)
		$Ceiling.color = Color(0.57, 0.53, 0.56, 1.0)
		speaker_player.play("play_music")
	else:
		var intro = preload("res://introduction.tscn").instance()
		intro.party_house = self
		add_child(intro)


func _on_camera_animation_finished(animation_name):
	match animation_name:
		"pan_camera":
			house_player.play("change")
		"pan_camera_back":
			emit_signal("house_transformed")


func _on_house_animation_finished(_anim_name):
	camera_player.play("pan_camera_back")
	speaker_player.play("play_music")
	MusicPlayer.play_street_song()


# Pan camera to outside view and stop the music.
func view_outside():
	camera_player.play("pan_camera")
	MusicPlayer.stop()
