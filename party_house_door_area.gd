extends Area2D

signal enter_party_house_area
signal exit_party_house_area

onready var label: = $EnterHouseLabel
onready var color_rect: = $ColorRect

export var first_entry: = true

var counter: = 0

func _emit_party_house_area_signal():
	emit_signal("enter_party_house_area")
	label.visible = true
	color_rect.visible = true

func _on_PartyHouseArea_body_entered(body):
	if first_entry:
		if counter > 1:
			_emit_party_house_area_signal()
	else:
		_emit_party_house_area_signal()
	
	counter += 1

func _on_PartyHouseArea_body_exited(body):
	emit_signal("exit_party_house_area")
	
	label.visible = false
	color_rect.visible = false
