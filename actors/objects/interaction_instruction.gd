extends KinematicBody2D

var target_velocity: = Vector2.ZERO
var target_y_position: = 0.0

func _physics_process(delta):
	move_and_slide(target_velocity)
	
	position.y = target_y_position

func _on_Player_move_label(current_velocity: Vector2, y_position: float, canInteract: bool):
	target_velocity = current_velocity
	target_y_position = y_position
	visible = canInteract
