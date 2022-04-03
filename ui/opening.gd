extends Node2D


func _ready():
	if Global.is_ending:
		Global.reset()
		Transition.wipe_out()
		MusicPlayer.play_intro_song()


func _process(_delta):
	if Input.is_action_just_pressed("interact") or \
			Input.is_action_just_pressed("jump"):
		if get_tree().change_scene("res://party_house.tscn") != OK:
			push_error("Critical error! Failed to load starting scene.")
