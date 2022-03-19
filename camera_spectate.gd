extends Camera2D


export(float) var speed = 600
# If true, do not use spectate controls.
export(bool) var is_tracked = false setget set_tracked


func _process(delta):
	if not is_tracked:
		var move = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		global_position += move * speed * delta


func set_tracked(enabled):
	is_tracked = enabled
