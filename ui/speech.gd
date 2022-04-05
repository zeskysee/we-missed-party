extends Node2D

# Marks if this speech node is playing or not.
export(bool) var is_playing = true
# If true, speech is skippable using the interact key.
export(bool) var is_skippable = false
# If true, automatically shows the bubble on ready.
export(bool) var show_on_ready = true
# Time in seconds until this speech is completed.
export(float) var time_to_finish = 1.5
# Used to set the Label text.
export(String, MULTILINE) var text = "Hi."

# Keep track of characters shown since last tick.
var characters_shown = 0
# If true, the speech is in the process of being destroyed.
var is_being_destroyed = false
# Time elapsed since this speech node is playing.
var time_elapsed: float = 0.0

# The AnimationPlayer to control the showing of the speech bubble.
onready var animation_player = $AnimationPlayer
# AudioStreamPlayer2D which plays the speech tick sound.
onready var audio_tick = $TickSound
# Bubble NinePatchRect to be resized according to the amount of text revealed.
onready var bubble = $Repositioning/Control/Bubble
# Label which will display the dialogue text.
onready var label = $Repositioning/Control/MarginContainer/Label


func _ready():
	label.text = text
	label.percent_visible = 0
	if show_on_ready:
		show_bubble()


func _process(delta):
	if is_playing:
		time_elapsed += delta
		label.percent_visible = time_elapsed / time_to_finish
		if characters_shown < label.visible_characters:
			audio_tick.play()
			characters_shown = label.visible_characters
		if label.percent_visible == 1:
			is_playing = false


func _input(event):
	if is_skippable and (event.is_action_pressed("interact") or \
			event.is_action_pressed("joy_interact") or \
			MouseController.is_interacting):
		if is_playing:
			time_elapsed = time_to_finish
		elif label.percent_visible == 1 and not is_being_destroyed:
			destroy()


func _on_destroy(animation_name):
	if animation_name == "show":
		queue_free()


# Destroys the speech bubble and removes it from the game.
func destroy():
	is_being_destroyed = true
	hide_bubble()
	animation_player.connect("animation_finished", self, "_on_destroy")


# Plays the hide animation of the speech bubble.
func hide_bubble():
	animation_player.play_backwards("show")


# Plays the speech.
func play():
	show_bubble()
	is_playing = true


# Plays the show animation of the speech bubble.
func show_bubble():
	animation_player.play("show")
