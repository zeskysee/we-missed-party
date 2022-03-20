extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL = Vector2.UP

onready var sprite: = $AnimatedSprite

export var speed: = Vector2(500.0, 900.0)
export var gravity: = 4000.0

var _velocity: = Vector2.ZERO

func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	speed: Vector2,
	is_jump_interrupted: bool
) -> Vector2:
	var new_velocity = linear_velocity
	new_velocity.x = speed.x * direction.x
	
	# make character move down
	new_velocity.y += gravity * get_physics_process_delta_time()
	
	# character jump
	if direction.y == -1.0:
		# overwrite to make character instant jump
		new_velocity.y = speed.y * direction.y
	
	# if did not press jump for long, drop the character
	if is_jump_interrupted:
		new_velocity.y = 0

	return new_velocity
	

func animate_character(direction: Vector2) -> void:
	if direction.x == 0:
		stand()
	else:
		walk(direction)

func stand() -> void:
	sprite.animation = "stand"
	sprite.flip_h = false
	sprite.stop()
	
func walk(direction: Vector2) -> void:
	sprite.animation = "walk"
	sprite.flip_h = direction.x < 0
	sprite.play()


func get_input_direction() -> Vector2:
	return Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			 -1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
		)
		
