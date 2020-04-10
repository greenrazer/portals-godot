extends Node

func _ready():
	$PortalA.set_linked_portal($PortalB)
	$PortalB.set_linked_portal($PortalA)
