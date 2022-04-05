extends Control
# UI instruction to tell the player that the current scene is skippable.


# Scene to skip to.
export(PackedScene) var scene = preload("res://neighborhood.tscn")
# If true, the instruction will pulsate on ready.
export(bool) var pulsate = true
# Radius of the pulsation.
export(float) var pulse_radius = 10.0

onready var label = $Label
onready var pulsation = $Pulsation
onready var tween = $Tween


func _ready():
	if pulsate:
		_on_pulsation_completed(label, "custom_styles/normal/shadow_size")
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


func _on_pulsation_completed(_object, _key):
	var shadow_size = label["custom_styles/normal"].shadow_size
	pulsation.interpolate_property(label["custom_styles/normal"], "shadow_size",
			shadow_size, pulse_radius if shadow_size == 0 else 0, 1.0)
	pulsation.start()


# Hides the skip instruction.
func hide():
	tween.interpolate_property(label, "rect_position",
			Vector2.ZERO, Vector2(-label.rect_size.x * 2, 0), 0.5)
	tween.start()


# Shows the skip instruction.
func show():
	tween.interpolate_property(label, "rect_position",
			Vector2(-label.rect_size.x * 2, 0), Vector2.ZERO, 0.5,
			Tween.TRANS_CUBIC)
	tween.start()


# Skips to scene.
func skip():
	if not Transition.is_transitioning:
		Global.reset()
		Transition.wipe_in(scene)
