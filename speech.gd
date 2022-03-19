extends Node2D


# Minimum size of the speech bubble.
const MINIMUM_SIZE = Vector2(50, 50)
const LINE_BREAK_THRESHOLD = 225

# Marks if this speech node is playing or not.
export(bool) var is_playing = true
# Time in seconds until this speech is completed.
export(float) var time_to_finish = 1.5
# Used to set the Label text.
export(String) var text = "Hi."

# Keep track of characters shown since last tick.
var characters_shown = 0
# Time elapsed since this speech node is playing.
var time_elapsed = 0


# The AnimationPlayer to control the showing of the speech bubble.
onready var animation_player = $AnimationPlayer
# Bubble NinePatchRect to be resized according to the amount of text revealed.
onready var bubble = $Repositioning/Control/Bubble
# Label which will display the dialogue text.
onready var label = $Repositioning/Control/Label


func _ready():
	label.text = text
	label.percent_visible = 0
	show_bubble()


func _process(delta):
	if is_playing:
		time_elapsed += delta
		label.percent_visible = time_elapsed / time_to_finish * \
				label.percent_visible
		# This is the amount of pixel space the font is taking up.
		var font_space = label.visible_characters * label.font.font_data.size
		bubble.rect_size.x = max(MINIMUM_SIZE.x, font_space)
		bubble.rect_size.y = max(MINIMUM_SIZE.y, floor(
				font_space / LINE_BREAK_THRESHOLD) * label.font.get_height())


# Plays the show animation of the speech bubble.
func show_bubble():
	animation_player.play("show")
