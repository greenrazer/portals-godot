extends Viewport


func _ready():
	pass

func _process(delta):
	get_node("../Shape").set_visible(false)
	get_node("../Shape").set_visible(true)
