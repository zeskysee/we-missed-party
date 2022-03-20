extends Node2D


onready var hover_player = $HoverPlayer
onready var monster_player = $MonsterPlayer
onready var first_speech = $AnimatedSprite/FirstSpeech


func _on_monster_player_animation_finished(anim_name):
	if anim_name == "appear":
		hover_player.play("hover")
		if is_instance_valid(first_speech):
			first_speech.play()


func appear():
	monster_player.play("appear")
