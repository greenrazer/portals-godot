extends Spatial

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED && Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE && Input.is_action_just_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
