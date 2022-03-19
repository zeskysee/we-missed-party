class_name NPCData
extends Reference
# Marks what NPC this is and where it should spawn in the parallax.

# The NPC scene to instantiate and spawn.
var npc_scene: PackedScene
# Offset spawn from origin of parallax. Vector2(0, 0) means player spawn.
var parallax_offset: Vector2
# Scaling of NPC.
var scale: Vector2


func _init(offset, resource = preload("res://actors/npc.tscn"),
		size = Vector2(0.7, 0.7)):
	parallax_offset = offset
	npc_scene = resource
	scale = size
