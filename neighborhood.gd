extends Node2D

export (PackedScene) var speech_scene

# Positions where NPC should be.
var npc_spots = [
	NPCData.new(Vector2(407, 0)),
	NPCData.new(Vector2(1920, 0))
]
var npc_counter: = 1

onready var camera = $Camera
onready var floor_loop = $Floor
onready var foreground = $ParallaxBackground/Foreground
onready var interaction_instruction = $InteractionInstruction
onready var npc_list = $NPCList
onready var player = $Player
onready var start_x = 0
onready var edge_x = foreground.motion_mirroring.x  # order is important


func _ready():
	# Initialize starting NPCs based on NPCData.
	respawn()
	respawn(false)
	Transition.transition_out()


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
		if npc.global_position.distance_to(player.global_position) > edge_x:
			npc.queue_free()
			
	# Respawn NPCs to take on the new loop.
	for data in npc_spots:
		var npc = data.npc_scene.instance()
		npc.id = str("npc_", npc_counter)
		npc_counter += 1
		
		var start = start_x if ahead else start_x - edge_x
		npc_list.add_child(npc)
		npc.global_position = Vector2(start, 510) + data.parallax_offset
		npc.scale = data.scale
		npc.connect("contact", player, "_on_NPC_contact")
		npc.connect("contact_loss", player, "_on_NPC_contact_loss")
		player.connect("interact", npc, "_on_Player_interact")
		npc.connect("reply", self, "_on_NPC_reply")


func _on_Player_invite(npc_id: String):
	var playerSpeech = speech_scene.instance()
	playerSpeech.text = "Let's come to my cool house party!"
	playerSpeech.is_skippable = true
	playerSpeech.position.x = player.position.x
	playerSpeech.position.y = player.position.y - 150
	playerSpeech.destroy_callback = funcref(player, "interact_npc")
	add_child(playerSpeech)
	

func _on_NPC_reply(npc_id: String, npc_position: Vector2):
	var npcSpeech = speech_scene.instance()
	npcSpeech.text = "Woah! I love party! Let's go."
	npcSpeech.is_skippable = true
	npcSpeech.position.x = npc_position.x
	npcSpeech.position.y = npc_position.y - 150
	npcSpeech.destroy_callback = funcref(player, "ask_npc_follow")
	add_child(npcSpeech)
