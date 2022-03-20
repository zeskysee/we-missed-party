extends CanvasLayer
# Transitioner to ensure smooth changing of scenes.
# The color pallete used for the ColorRects in this scene is from:
# https://colorhunt.co/palette/557b8339aea9a2d5abe5efc1
# Really cool stuff.


# Just exposes the animation_player finished signal for ease-of-use.
signal completed(animation_name)

# As usual, the AnimationPlayer to animate the transition.
onready var animation_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer


func _on_animation_finished(anim_name):
	emit_signal("completed", anim_name)


func transition_in():
	animation_player.play("in")
	audio_player.play()


func transition_out():
	animation_player.play("out")
