extends Node

func _process(_delta):
	$PortalA.update_view($PortalB)
	$PortalB.update_view($PortalA)
