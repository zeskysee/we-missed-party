extends Actor

var is_move_to_player_back: = false
var is_follow_player = false

func _physics_process(delta):
	
	# _velocity
	if is_move_to_player_back:
		var direction = Vector2.LEFT
		_velocity.x = speed.x * direction.x
		_velocity = move_and_slide(_velocity)
		.walk(direction)
		
	if is_follow_player:
		var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
		var direction: = _get_direction()
		_velocity = .calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
		# engine automatically move character in move_and_slide function
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
		.animate_character(direction)
	
	
func _get_direction() -> Vector2:
	if is_follow_player:
		return Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
		)
	else:
		return Vector2.ZERO

func move_to_position():
	is_move_to_player_back = true
	
func swap_direction():
	.stand()
	is_move_to_player_back = false
	is_follow_player = true
	
