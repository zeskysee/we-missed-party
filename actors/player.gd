extends Actor

onready var interact_label = $InteractLabel
onready var animated_sprite = $AnimatedSprite

var in_contact: = false

func _physics_process(delta):
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	
	var direction: = get_direction()
	
	_velocity = .calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
	# engine automatically move character in move_and_slide function
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	.animate_character(direction)
	
	var face_back: bool = animated_sprite.flip_h
	interact_label.visible = not face_back and in_contact
	

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		 -1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)


func _on_NPC_contact():
	in_contact = true

func _on_NPC_contact_loss():
	in_contact = false
