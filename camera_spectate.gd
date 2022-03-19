extends Camera2D


export(float) var speed = 600


func _process(delta):
	var move = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	global_position += move * speed * delta
