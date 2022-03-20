extends Area2D

signal contact
signal contact_loss
signal reply

export var id: = "npc_1"

func _on_NPC_body_entered(body):
	emit_signal("contact", id)

func _on_NPC_body_exited(body):
	emit_signal("contact_loss")

func _on_Player_interact(npc_id: String):
	if npc_id == id:
		emit_signal("reply", id, position)


