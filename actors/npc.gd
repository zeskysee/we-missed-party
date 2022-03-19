extends Area2D

signal contact
signal contact_loss

func _on_NPC_body_entered(body):
	emit_signal("contact")

func _on_NPC_body_exited(body):
	emit_signal("contact_loss")
