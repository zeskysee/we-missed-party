extends CanvasLayer
# Transitioner to ensure smooth changing of scenes.
# The color pallete used for the ColorRects in this scene is from:
# https://colorhunt.co/palette/557b8339aea9a2d5abe5efc1
# Really cool stuff.


# Scene to transition to. If null, wipe_in() will not change scenes.
var scene: PackedScene
# Is set to true if the transition is still being played.
var is_transitioning = false

onready var animation_player = $AnimationPlayer
onready var audio_player = $AudioStreamPlayer
onready var first = $First
onready var second = $Second
onready var third = $Third
onready var fourth = $Fourth


func _ready():
	if get_tree().root.connect("size_changed", self, "_on_size_changed") == OK:
		call_deferred("_on_size_changed")
	else:
		push_warning("Failed to connect resize signal to transition " + \
				"rectangles. Transitions may fail to match viewport size.")


func _on_animation_finished(anim_name):
	if anim_name == "in":
		is_transitioning = false
		if scene and get_tree().change_scene_to(scene) != OK:
			push_error("Failed to transition to scene: %s" % scene)
			scene = null


func _on_size_changed():
	var new_size = get_viewport().size * Vector2(16, 9)
	first.rect_size = new_size
	second.rect_size = new_size
	third.rect_size = new_size
	fourth.rect_size = new_size


# Wipes the transition squares in, then changes to given scene.
func wipe_in(packed_scene: PackedScene = null):
	if not is_transitioning:
		is_transitioning = true
		scene = packed_scene
		animation_player.play("in")
		audio_player.play()


# Called after scene is loaded to clear the transition squares.
func wipe_out():
	animation_player.play("out")
