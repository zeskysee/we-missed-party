extends Node2D


const DANCING_NPC = preload("res://dancing_npc.tscn")


# Becomes true if is transitioning to the neighborhood.
var is_transitioning = false
# If true, NPCs spawn left side of the room in ending. False means right side.
# This will be alternated on every spawn.
var spawn_left = true
# List of possible [scale, y-position] for random y adjustment in NPC spawns.
var random_scale_y = [[0.085, 502], [0.082, 497], [0.08, 492]]

onready var camera_player = $CameraPlayer
onready var house_player = $Outer/AnimationPlayer
onready var player_player = $PlayerPlayer
onready var magic_monster = $MagicMonster
onready var first_speech = $FirstSpeech
onready var second_speech = $SecondSpeech
onready var third_speech = $ThirdSpeech
onready var npc_spawns = $NPCSpawns

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
	if Global.is_ending:
		play_ending()
	pass

func _input(event):
	if Global.is_ending and not is_transitioning and \
			(event.is_action_pressed("interact") or \
			event.is_action_pressed("jump")):
		is_transitioning = true
		Transition.connect("completed", self, "_on_return_to_main_menu")
		Transition.transition_in()
	elif not Global.is_ending and event.is_action_pressed("skip_cutscene") \
			and not is_transitioning:
		rearrange_for_party()
		start_transition()
		if not MusicPlayer.street_player.playing:
			MusicPlayer.play_street_song()


# Monster appears after first speech.
func _on_first_speech_tree_exited():
	magic_monster.appear()


# Camera pans after second speech.
func _on_second_speech_tree_exited():
	camera_player.play("pan_camera")
	MusicPlayer.stop()


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
	#props.visible = true
	speaker_player.play("play_music")
	MusicPlayer.play_street_song()


func _on_return_to_main_menu(anim_name):
	if anim_name == "in":
		get_tree().change_scene("res://opening.tscn")


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
	set_ending_text(Global.get_ending_text())
	randomize()
	spawn_npcs()


func pop():
	popper_one.play("pop")
	popper_two.play("pop")
	cake.visible = false
	cake_cut.visible = true
	banner_label.visible = true


# Sorry for the if checks, rushing to complete. Checks are there because
# player can skip cutscene at any time and I need to destroy the signals or
# Godot engine will throw error, which is not very nice.
func rearrange_for_party():
	camera_player.disconnect("animation_finished", self,
			"_on_camera_animation_finished")
	var monster_first = get_node_or_null(
			"MagicMonster/AnimatedSprite/FirstSpeech")
	if monster_first:
		monster_first.disconnect("tree_exited", self,
				"_on_monster_first_tree_exited")
	if is_instance_valid(first_speech):
		first_speech.disconnect("tree_exited", self,
				"_on_first_speech_tree_exited")
	if is_instance_valid(second_speech):
		second_speech.disconnect("tree_exited", self,
				"_on_second_speech_tree_exited")
	var fourth_speech = get_node_or_null("FourthSpeech")
	if third_speech:
		third_speech.disconnect("tree_exited", fourth_speech, "play")
	var monster_second = get_node_or_null(
			"MagicMonster/AnimatedSprite/SecondSpeech")
	if fourth_speech and monster_second:
		fourth_speech.disconnect("tree_exited", monster_second, "play")
	var monster_third = get_node_or_null(
			"MagicMonster/AnimatedSprite/ThirdSpeech")
	var monster_fourth = get_node_or_null(
			"MagicMonster/AnimatedSprite/FourthSpeech")
	if monster_third and monster_fourth:
		monster_third.disconnect("tree_exited", monster_fourth, "play")
	if monster_fourth:
		monster_fourth.disconnect("tree_exited", self, "start_transition")
	for node in [first_speech, second_speech, third_speech, fourth_speech,
			monster_first, monster_second, monster_third, monster_fourth]:
		if is_instance_valid(node):
			node.queue_free()


func set_ending_text(text):
	banner_label.text = text


# Spawns the party go-er depending on the global ending state.
func spawn_npcs():
	for i in range(Global.total_number_of_npc):
		# 1. Get the resource or sprite of the npc to spawn.
		var dancing_npc = DANCING_NPC.instance()
		# 2. Spawn them at any x-position from 0 to 1024. y-position ~492.
		npc_spawns.add_child(dancing_npc, true)
		var index = randi() % random_scale_y.size()
		var x_location = rand_range(100, 462) if spawn_left else \
				rand_range(562, 924)
		dancing_npc.sprite.z_index = random_scale_y.size() - index
		dancing_npc.sprite.scale = Vector2(random_scale_y[index][0],
				random_scale_y[index][0])
		dancing_npc.global_position = Vector2(x_location,
				random_scale_y[index][1])
		if dancing_npc.global_position.x > 512:
			dancing_npc.scale.x *= -1
		spawn_left = !spawn_left


func start_transition():
	if not is_transitioning:
		is_transitioning = true
		# warning-ignore:return_value_discarded
		Transition.connect("completed", self, "start_game")
		Transition.transition_in()


func start_game(transition_name):
	if transition_name == "in":
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://neighborhood.tscn")
