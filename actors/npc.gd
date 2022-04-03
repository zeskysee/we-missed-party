extends Actor

signal reply
signal moved_back

var target_position: = Vector2.ZERO
var is_move_to_player_back: = false
var is_follow_player = false
# Reference to the player this npc body is following.
var player


onready var area: = $Area2D

func _physics_process(delta):

	if is_move_to_player_back:
		if position.x <= target_position.x:
			swap_direction()
			call_deferred("emit_signal", "moved_back")
		else	:
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
	
func _on_Player_interact(npc_id: String, target_player):
	if npc_id == name:
		player = target_player
		emit_signal("reply", name, position)

func follow_player(player_position: Vector2):
	target_position = player_position
	move_to_position()
	
	area.area_collision.disabled = true
