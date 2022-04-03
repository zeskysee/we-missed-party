extends Area2D

signal contact
signal contact_loss

onready var area_collision: = $AreaCollision

func _on_NPC_body_entered(body):
	emit_signal("contact", get_parent().name)

func _on_NPC_body_exited(body):
	emit_signal("contact_loss")

