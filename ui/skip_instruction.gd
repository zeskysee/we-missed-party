extends CanvasLayer
# UI instruction to tell the player that the current scene is skippable.


signal skipped


# If set to true, the instruction will be shown on ready.
export(bool) var show_on_ready = false

# Will be set to true once a skip is initiated.
var is_skipping = false

# Playback control for the animation states.
onready var playback: AnimationNodeStateMachinePlayback = $AnimationTree[
		"parameters/playback"]


func _ready():
	if show_on_ready:
		show()


func _input(event):
	if event.is_action_pressed("skip_cutscene"):
		skip()


# Callback that triggers when mouse is on ColorRect of the skip instruction.
func _on_gui_input(event):
	# event is always a InputMouseEvent. This is because the gui_input signal
	# for Control nodes only capture mouse inputs.
	if event.is_action_pressed("interact"):
		skip() # skip on left-click


# Hides the skip instruction.
func hide():
	playback.travel("reset")


# Shows the skip instruction.
func show():
	playback.travel("show")


# Skips to gameplay.
func skip():
	if not is_skipping:
		is_skipping = true
		Global.reset()
		Transition.wipe_in(preload("res://neighborhood.tscn"))
		emit_signal("skipped")
