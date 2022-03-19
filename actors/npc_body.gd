extends Actor

func _physics_process(delta):
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	
	var direction: = get_direction()
	
	_velocity = .calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
	# engine automatically move character in move_and_slide function
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	.animate_character(direction)
	
func get_direction() -> Vector2:
	return Vector2.ZERO
