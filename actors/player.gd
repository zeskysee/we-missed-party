extends Actor

signal interact

onready var interact_label = $InteractLabel
onready var animated_sprite = $AnimatedSprite

var in_contact: = false
var is_interacting: = false

func _physics_process(delta):
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	
	var direction: = get_direction()
	
	_velocity = .calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
	# engine automatically move character in move_and_slide function
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	.animate_character(direction)
	
	var face_back: bool = animated_sprite.flip_h
	var can_interact = not face_back and in_contact and not is_interacting
	interact_label.visible = can_interact
	
	if can_interact and Input.is_action_pressed("interact"):
		is_interacting = true
		emit_signal("interact")
	

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		 -1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)


func _on_NPC_contact():
	in_contact = true

func _on_NPC_contact_loss():
	in_contact = false
	is_interacting = false
