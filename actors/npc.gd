extends Area2D

signal contact
signal contact_loss
signal reply

export var is_moving_to_player_back: = false
export var target_position: = Vector2.ZERO

onready var npc_body: = $KinematicBody2D
onready var area_collision: = $AreaCollision

func _physics_process(delta):
	if is_moving_to_player_back:
		var current_body_position_x = position.x + npc_body.position.x
		
		if current_body_position_x <= target_position.x:
			npc_body.swap_direction()
			is_moving_to_player_back = false

func _on_NPC_body_entered(body):
	emit_signal("contact", name)

func _on_NPC_body_exited(body):
	emit_signal("contact_loss")

func _on_Player_interact(npc_id: String):
	if npc_id == name:
		emit_signal("reply", name, position)

func follow_player(player_position: Vector2):
	is_moving_to_player_back = true
	target_position = player_position
	npc_body.move_to_position()
	
	area_collision.disabled = true
