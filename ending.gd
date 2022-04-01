extends Node2D


# If true, NPCs spawn left side of the room in ending. False means right side.
# This will be alternated on every spawn.
var spawn_left = true
# List of possible [scale, y-position] for random y adjustment in NPC spawns.
var random_scale_y = [[0.085, 502], [0.082, 497], [0.08, 492]]

# Node to spawn the NPCs in.
onready var npc_spawns = $NPCSpawns


func _ready():
	Global.is_ending = true
	$PartyProps/Banner/Label.text = Global.get_ending_text()
	$MagicMonster.appear()
	randomize()
	spawn_npcs()


# Return to opening scene on interact.
func _input(event):
	if event.is_action_pressed("interact") or event.is_action_pressed("jump"):
		Transition.wipe_in(preload("res://ui/opening.tscn"))


# Spawns the party go-er depending on the global ending state.
func spawn_npcs():
	for _i in range(Global.total_number_of_npc):
		# 1. Get the resource or sprite of the npc to spawn.
		var dancing_npc = preload("res://dancing_npc.tscn").instance()
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
