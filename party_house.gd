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


func _ready():
	# Get ending state from global, if true, then play ending.
	#if true:
	#	play_ending()
	pass


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


# Rearanges the scene for the ending.
func play_ending():
	rearrange_for_party()
	_on_first_speech_tree_exited()
	props.visible = true
	speaker_player.play("play_music")
	pop()
	player_player.play("dance")
	magic_monster.global_position.y = 250
	$Backwall.color = Color(0.71, 0.67, 0.71, 1.0)
	$Ceiling.color = Color(0.57, 0.53, 0.56, 1.0)
	#set_ending_text(Global.get_ending_text())
	#randomize()
	#spawn_npc()


func pop():
	popper_one.play("pop")
	popper_two.play("pop")
	cake.visible = false
	cake_cut.visible = true
	banner_label.visible = true


func rearrange_for_party():
	var monster_first = $MagicMonster/AnimatedSprite/FirstSpeech
	monster_first.disconnect("tree_exited", self,
			"_on_monster_first_tree_exited")
	first_speech.disconnect("tree_exited", self,
			"_on_first_speech_tree_exited")
	second_speech.disconnect("tree_exited", self,
			"_on_second_speech_tree_exited")
	var fourth_speech = $FourthSpeech
	third_speech.disconnect("tree_exited", fourth_speech, "play")
	var monster_second = $MagicMonster/AnimatedSprite/SecondSpeech
	fourth_speech.disconnect("tree_exited", monster_second, "play")
	var monster_third = $MagicMonster/AnimatedSprite/ThirdSpeech
	var monster_fourth = $MagicMonster/AnimatedSprite/FourthSpeech
	monster_third.disconnect("tree_exited", monster_fourth, "play")
	monster_fourth.disconnect("tree_exited", self, "start_transition")
	for node in [first_speech, second_speech, third_speech, fourth_speech,
			monster_first, monster_second, monster_third, monster_fourth]:
		node.queue_free()


func set_ending_text(text):
	banner_label.text = text


# Spawns the party go-er depending on the global ending state.
func spawn_npc(npcs = [preload("res://actors/npc.tscn")]):
	for npc in npcs:
		# 1. Get the resource or sprite of the npc to spawn.
		# 2. Spawn them at any x-position from 0 to 1024. y-position ~492.
#		var instance = npc.instance()
#		add_child(instance)
#		instance.global_position = Vector2(rand_range(100, 924), 492)
#		if instance.global_position.x < 512:
#			instance.scale.x *= -1
		pass


func start_transition():
	Transition.transition_in()
	# warning-ignore:return_value_discarded
	Transition.connect("completed", self, "start_game")


func start_game(transition_name):
	if transition_name == "in":
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://neighborhood.tscn")
