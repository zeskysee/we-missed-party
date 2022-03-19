extends Node2D


# Positions where NPC should be.
var npc_spots = [
	NPCData.new(Vector2(407, 0))
]

onready var camera = $Camera
onready var floor_loop = $Floor
onready var foreground = $ParallaxBackground/Foreground
onready var npc_list = $NPCList
onready var player = $Player
onready var start_x = 0
onready var edge_x = foreground.motion_mirroring.x  # order is important


func _physics_process(delta):
	floor_loop.global_position.x = player.global_position.x
	# Update the position loop.
	var viewport_half_x = get_viewport().size.x / 2
	if camera.global_position.x + viewport_half_x > start_x + abs(edge_x):
		start_x += edge_x
		respawn()
	elif camera.global_position.x - viewport_half_x / 2 < start_x - abs(edge_x) + \
			viewport_half_x + 200:
		start_x -= edge_x
		respawn()


func respawn():
	# Remove all NPCs who were left behind.
	for npc in npc_list.get_children():
		# TODO: Following NPCs should either be moved out of this list,
		# or have a check so following NPCs don't get destroyed.
		npc.queue_free()
	# Respawn NPCs to take on the new loop.
	for data in npc_spots:
		var npc = data.npc_scene.instance()
		npc_list.add_child(npc)
		npc.global_position = Vector2(start_x, 510) + data.parallax_offset
		npc.scale = data.scale
		npc.connect("contact", player, "_on_NPC_contact")
		npc.connect("contact_loss", player, "_on_NPC_contact_loss")
