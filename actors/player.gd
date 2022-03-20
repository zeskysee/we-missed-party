extends Actor

signal interact
signal invite
signal move_label
signal follow
signal enter_party_house

export var label_height: = 50.0

onready var animated_sprite = $AnimatedSprite
onready var collision_shape = $CollisionShape2D

# idle | interacting | wait_reply | wait_follow
var status = "idle"
var in_contact: = false
var in_conversation = false
var at_party_house_door: = false
var npc_id_in_contact: = ""


func _physics_process(delta):
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
		
	var direction: = .get_input_direction()
	
	_velocity = Vector2.ZERO if in_conversation else .calculate_move_velocity(
			_velocity, direction, speed, is_jump_interrupted)
	
	# engine automatically move character in move_and_slide function
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

	.animate_character(direction)
		
	
	var face_back: bool = animated_sprite.flip_h
	var can_interact = not face_back and in_contact and status == "idle"
	
	emit_signal("move_label", _velocity, position.y - collision_shape.get_shape().height - label_height, can_interact)
	
	_invite(can_interact)
	_enter_party_house()	


func _invite(can_interact: bool):
	if can_interact and Input.is_action_pressed("interact"):
		in_conversation = true
		status = "interacting"
		emit_signal("invite", npc_id_in_contact)

func _enter_party_house():
	if at_party_house_door and Input.is_action_pressed("interact"):
		at_party_house_door = false
		emit_signal("enter_party_house")
		
func interact_npc(carry_over_id):
	status = "wait_reply"
	emit_signal("interact", carry_over_id)

func available():
	in_conversation = false
	status = "idle"

func _on_NPC_contact(npc_id):
	in_contact = true
	npc_id_in_contact = npc_id

func _on_NPC_contact_loss():
	status = "idle"
	in_contact = false
	npc_id_in_contact = ""


func _on_PartyHouseDoorArea_enter_party_house_area():
	at_party_house_door = true

func _on_PartyHouseDoorArea_exit_party_house_area():
	at_party_house_door = false
