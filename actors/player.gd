extends Actor

signal interact
signal move_label
signal follow

export var label_height = 50.0

onready var animated_sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D

var in_contact: = false
var is_interacting: = false
var npc_id_in_contact: = ""


func _physics_process(delta):
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	
	var direction: = get_direction()
	
	_velocity = .calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
	# engine automatically move character in move_and_slide function
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	.animate_character(direction)
	
	var face_back: bool = animated_sprite.flip_h
	var can_interact = not face_back and in_contact and not is_interacting
	
	emit_signal("move_label", _velocity, position.y - collision_shape.get_shape().height - label_height, can_interact)
	
	if can_interact and Input.is_action_pressed("interact"):
		is_interacting = true
		emit_signal("interact", npc_id_in_contact)
		emit_signal("follow", npc_id_in_contact, position.x)
	

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		 -1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)


func _on_NPC_contact(npc_id):
	in_contact = true
	npc_id_in_contact = npc_id

func _on_NPC_contact_loss():
	in_contact = false
	is_interacting = false
	npc_id_in_contact = ""

