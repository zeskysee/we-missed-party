extends Node
# A mouse controller to allow the game to be played with only left-clicks.


# If true, is_interacting will be true on directional mouse clicks.
var ignore_direction = true
# If true, the mouse is in the middle of the screen and wants to interact.
var is_interacting = false
# The horizontal direction in which the mouse control wants to move towards.
var x_direction = 0


func _physics_process(_delta):
	if Input.is_action_pressed("mouse_interact"):
		var viewport = get_viewport()
		var position = viewport.get_mouse_position()
		if position.x < viewport.size.x * 0.25:
			x_direction = -1
			is_interacting = ignore_direction
		elif position.x > viewport.size.x * 0.75:
			x_direction = 1
			is_interacting = ignore_direction
		else:
			x_direction = 0
			is_interacting = true
	else:
		reset()


func reset():
	is_interacting = false
	x_direction = 0
