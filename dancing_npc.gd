extends Node2D


var step = 0

onready var sprite = $Sprite
onready var tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	jump()


func _on_tween_completed(_object, _key):
	# I dunno why I use match here, could just be if-else but meh
	match step:
		0:
			fall()
		1:
			jump()


# Makes a jump animation with a random delay, NPC is bad at following beats.
func jump():
	step = 0
	tween.interpolate_property(sprite, "position",
		Vector2(0, 0), Vector2(0, -14), 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, rand_range(0.5, 2.0))
	tween.start()


func fall():
	step = 1
	tween.interpolate_property(sprite, "position",
		Vector2(0, -14), Vector2(0, 0), 0.1, Tween.TRANS_LINEAR)
	tween.start()
