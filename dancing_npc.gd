extends Node2D
# A dancing NPC with a sprite that tweens up and down.


# Height in pixels for the sprite to jump in the dance.
export(float) var jump_height = 14

# Checks if the dancing NPC is falling or not.
var is_falling: bool

onready var sprite = $Sprite
onready var tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	jump()


func _on_tween_completed(_object, _key):
	if not is_falling:
		fall()
	else:
		jump()


func fall():
	is_falling = true
	tween.interpolate_property(sprite, "position",
		Vector2(0, -jump_height), Vector2.ZERO, 0.1, Tween.TRANS_LINEAR)
	tween.start()


# Makes a jump animation with a random delay, NPC is bad at following beats.
func jump():
	is_falling = false
	tween.interpolate_property(sprite, "position",
		Vector2.ZERO, Vector2(0, -jump_height), 0.1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, rand_range(0.5, 2.0))
	tween.start()
