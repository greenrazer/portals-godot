extends Node

var player_cam

func _ready():
	var texA = $PortalA/Viewport.get_texture()
	var matB = $PortalB/Shape/Mesh/Outside.material_override
	matB.set_shader_param("texture_albedo", texA)
	$PortalA/Viewport.size = get_viewport().size

	var texB = $PortalB/Viewport.get_texture()
	var matA = $PortalA/Shape/Mesh/Outside.material_override
	matA.set_shader_param("texture_albedo", texB)
	$PortalB/Viewport.size = get_viewport().size
	
	player_cam = get_node("../../../Steve/Head/Camera")

func _process(_delta):
	var player_portalA_dist = (player_cam.global_transform.origin - $PortalA.global_transform.origin).length()
	var portalB_trans = $PortalB.global_transform * $PortalA.global_transform.inverse() * player_cam.global_transform
	$PortalB/Viewport/Camera.set_transform(portalB_trans)
	$PortalB/Viewport/Camera.set_znear(player_portalA_dist)
	$PortalA/Viewport.size = get_viewport().size
	
	var player_portalB_dist = (player_cam.global_transform.origin - $PortalB.global_transform.origin).length()
	var portalA_trans = $PortalA.global_transform * $PortalB.global_transform.inverse() * player_cam.global_transform
	$PortalA/Viewport/Camera.set_transform(portalA_trans)
	$PortalA/Viewport/Camera.set_znear(player_portalB_dist)
	$PortalB/Viewport.size = get_viewport().size
