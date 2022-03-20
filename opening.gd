extends Node2D


func _ready():
	if Global.is_ending:
		Transition.transition_out()
		MusicPlayer.play_intro_song()
		Global.reset()


func _process(delta):
	if Input.is_action_just_pressed("interact") or \
			Input.is_action_just_pressed("jump"):
		get_tree().change_scene("res://party_house.tscn")
