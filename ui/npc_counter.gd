extends CanvasLayer
# UI control for counting follower NPCs.


onready var animation_player = $AnimationPlayer
onready var left_label = $Left/Label
onready var top_label = $Top/Label


func _ping():
	animation_player.play("ping")


func _set_text(text):
	left_label.text = text
	top_label.text = text


func update(count):
	_ping()
	_set_text(str(count))
