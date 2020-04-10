extends Spatial

var player_cam

func _ready():
	var texA = $Viewport.get_texture()
	var matA = $Shape/Mesh/Outside.material_override
	matA.set_shader_param("texture_albedo", texA)
	$Viewport.size = get_viewport().size
	
	player_cam = get_node("../../../../Steve/Head/Camera")

func update_view(linked_portal):
	var linked_trans = linked_portal.global_transform * global_transform.inverse() * player_cam.global_transform
	var camera_to_linked_portal_dist = (player_cam.global_transform.origin - global_transform.origin).length()
	$Viewport/Camera.set_transform(linked_trans)
	$Viewport/Camera.set_znear(camera_to_linked_portal_dist)
	$Viewport.size = get_viewport().size
