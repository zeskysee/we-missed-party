extends Actor

var is_move_to_player_back: = false
var is_follow_player = false
# Reference to the player this npc body is following.
var player

func _physics_process(delta):

	if is_move_to_player_back:
		var direction = Vector2.LEFT
		_velocity.x = speed.x * direction.x
		_velocity = move_and_slide(_velocity)
		.walk(direction)
		
	if is_follow_player and player != null and not player.in_conversation:
		var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
		var direction: = .get_input_direction()
		_velocity = .calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
		# engine automatically move character in move_and_slide function
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
		.animate_character(direction)
	

func move_to_position():
	is_move_to_player_back = true
	
func swap_direction():
	.stand()
	is_move_to_player_back = false
	is_follow_player = true
	
