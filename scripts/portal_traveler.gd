extends KinematicBody
class_name PortalTraveler

var prev_offset
var velocity
var in_portal_field

func _ready():
	prev_offset = Vector3()
	velocity = Vector3()
	in_portal_field = false
