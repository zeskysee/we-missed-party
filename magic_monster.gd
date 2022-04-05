extends Node2D
# It's a fluffly magic monster!


# This signal is emitted when the monster fully appears in the scene.
signal appeared


# Monster's AnimationPlayer.
onready var monster_player = $MonsterPlayer


# Callback for when monster_player animation finishes playing.
func _on_animation_finished(animation_name):
	if animation_name == "appear":
		emit_signal("appeared")


# Plays the "appear" animation of the monster.
func appear():
	monster_player.play("appear")
