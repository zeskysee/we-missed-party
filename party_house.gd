extends Node2D


onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	#animation_player.play("intro")
	pass


func _on_test_destroy_timeout():
	var speech = get_node_or_null("Speech")
	if is_instance_valid(speech):
		speech.destroy()
