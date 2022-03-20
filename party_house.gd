extends Node2D


onready var camera_player = $CameraPlayer
onready var house_player = $Outer/AnimationPlayer
onready var player_player = $PlayerPlayer
onready var magic_monster = $MagicMonster
onready var first_speech = $FirstSpeech
onready var second_speech = $SecondSpeech
onready var third_speech = $ThirdSpeech

# Party props.
onready var props = $Furniture/PartyProps
onready var banner_label = $Furniture/PartyProps/Banner/Label
onready var cake = $Furniture/PartyProps/CakePlate/Cake
onready var cake_cut = $Furniture/PartyProps/CakePlate/CakeCut
onready var popper_one = $Furniture/PartyProps/PartyPopper/AnimationPlayer
onready var popper_two = $Furniture/PartyProps/PartyPopper2/AnimationPlayer
onready var speaker_player = $Furniture/Speaker/SpeakerPlayer


# Monster appears after first speech.
func _on_first_speech_tree_exited():
	magic_monster.appear()


# Camera pans after second speech.
func _on_second_speech_tree_exited():
	camera_player.play("pan_camera")


# Player's second speech plays after monster's first speech.
func _on_monster_first_tree_exited():
	second_speech.play() # What is this magical monster?
	player_player.play("shocked")


func _on_camera_animation_finished(anim_name):
	if anim_name == "pan_camera":
		house_player.play("change")
	else:
		third_speech.play()


func _on_house_animation_finished(_anim_name):
	camera_player.play("pan_camera_back")
	props.visible = true
	speaker_player.play("play_music")
	# TODO: Play music.


func pop():
	popper_one.play("pop")
	popper_two.play("pop")
	cake.visible = false
	cake_cut.visible = true
	banner_label.visible = true


func set_ending_text(text):
	banner_label.text = text


func start_transition():
	Transition.transition_in()
	# warning-ignore:return_value_discarded
	Transition.connect("completed", self, "start_game")


func start_game(transition_name):
	if transition_name == "in":
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://neighborhood.tscn")
