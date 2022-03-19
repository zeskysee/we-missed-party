extends Node2D


onready var animation_player = $AnimationPlayer
onready var magic_monster = $MagicMonster


# Called when the node enters the scene tree for the first time.
func _ready():
	#animation_player.play("intro")
	pass


func _on_test_destroy_timeout():
	var speech = get_node_or_null("FirstSpeech")
	if is_instance_valid(speech):
		speech.destroy()


func _on_first_speech_tree_exited():
	magic_monster.appear()


func set_ending_text(text):
	pass

