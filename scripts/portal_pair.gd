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
	var portalB_trans = $PortalB.global_transform * $PortalA.global_transform.inverse() * player_cam.global_transform
	$PortalB/Viewport/Camera.set_transform(portalB_trans)
	$PortalA/Viewport.size = get_viewport().size
