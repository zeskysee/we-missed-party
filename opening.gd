extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		get_tree().change_scene("res://party_house.tscn")
