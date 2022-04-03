extends Node2D

export (PackedScene) var speech_scene
export (PackedScene) var party_house_door_scene

# Positions where NPC should be.
var npc_spots = [
	NPCData.new(Vector2(407, 0)),
	NPCData.new(Vector2(1920, 0))
]
var spawn_npc_counter: = 1
var follow_npc_counter: = 0
var area_counter: = 0
var target_npc_name: = ""
var target_npc_position: = Vector2.ZERO

onready var floor_loop = $Floor
onready var foreground = $ParallaxBackground/Foreground
onready var interaction_instruction = $InteractionInstruction
onready var npc_list = $NPCList
onready var player = $Player
onready var start_x = 0
onready var edge_x = foreground.motion_mirroring.x  # order is important

onready var ui_npc_animation_player = $UINPCCount/UINPCPlayer
onready var ui_npc_label = $UINPCCount/Control/Label


func _ready():
	# Initialize starting NPCs based on NPCData.
	respawn()
	respawn(false)
	Transition.wipe_out()
	MusicPlayer.play_street_song()


func _physics_process(_delta):
	floor_loop.global_position.x = player.global_position.x
	# Update the position loop.
	var viewport_half_x = get_viewport().size.x / 2
	if player.global_position.x + viewport_half_x > start_x + edge_x:
		start_x += edge_x
		respawn()
	elif player.global_position.x - viewport_half_x < start_x - edge_x:
		start_x -= edge_x
		respawn(false)


func respawn(ahead = true):
	# Remove all NPCs who were left behind.
	for npc in npc_list.get_children():
		if npc.name.begins_with("npc"):
			if npc.npc_body.global_position.distance_to(player.global_position) > edge_x:
				npc.queue_free()
		else:
			if npc.global_position.distance_to(player.global_position) > edge_x:
				npc.queue_free()
	
	# Respawn NPCs to take on the new loop.
	for data in npc_spots:
		var npc = data.npc_scene.instance()
		npc.name = str("npc_", spawn_npc_counter)
		spawn_npc_counter += 1
		
		var start = start_x if ahead else start_x - edge_x
		npc_list.add_child(npc)
		npc.global_position = Vector2(start, 510) + data.parallax_offset
		npc.scale = data.scale
		npc.connect("contact", player, "_on_NPC_contact")
		npc.connect("contact_loss", player, "_on_NPC_contact_loss")
		player.connect("interact", npc, "_on_Player_interact", [player])
		npc.connect("reply", self, "_on_NPC_reply")
		npc.connect("moved_back", self, "_on_NPC_moved_back")
	
	var start = start_x if ahead else start_x - edge_x
	var party_house_door_area = party_house_door_scene.instance()
	party_house_door_area.first_entry = area_counter == 0
	npc_list.add_child(party_house_door_area)
	
	area_counter += 1
	
	party_house_door_area.global_position = Vector2(start, 0)
	party_house_door_area.connect("enter_party_house_area", player, "_on_PartyHouseDoorArea_enter_party_house_area")
	party_house_door_area.connect("exit_party_house_area", player, "_on_PartyHouseDoorArea_exit_party_house_area")


func _on_Player_invite(npc_id: String):
	var player_speech = speech_scene.instance()
	player_speech.text = "Let's come to my cool house party!"
	player_speech.is_skippable = true
	player_speech.position.x = player.position.x
	player_speech.position.y = player.position.y - 150
	player_speech.connect("tree_exited", player, "interact_npc", [npc_id])
	add_child(player_speech)
	

func _on_NPC_reply(npc_id: String, npc_position: Vector2):
	target_npc_name = npc_id
	target_npc_position = npc_position

	var npc_speech = speech_scene.instance()
	npc_speech.text = "Woah! I love party! Let's go!"
	npc_speech.is_skippable = true
	npc_speech.position.x = npc_position.x
	npc_speech.position.y = npc_position.y - 150
	npc_speech.destroy_callback = funcref(self, "npc_follow_player")
	add_child(npc_speech)


func npc_follow_player():
	follow_npc_counter += 1
	Global.total_number_of_npc += 1
	# Play ping animation.
	ui_npc_animation_player.play("ping")
	ui_npc_label.text = str(follow_npc_counter)
	
	var target_npc = npc_list.get_node(target_npc_name)
	var target_position = player.position
	
	# move to next blank behind player
	# to fix positioning issue
	target_position.x -= (30) + follow_npc_counter * 120
	target_npc.follow_player(target_position)


func _on_NPC_moved_back():
	player.available()


func _on_Player_enter_party_house():
	Global.is_ending = true
	get_tree().change_scene("res://party_house.tscn")
