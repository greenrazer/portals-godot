extends KinematicBody
class_name PortalTraveler

var prev_offset
var velocity

func _ready():
	prev_offset = Vector3()
	velocity = Vector3()
