extends Spatial

var player_cam
var linked_portal
var travelers_to_me
var just_started

func _ready():
	var texA = $Viewport.get_texture()
	var matA = $Shape/Mesh/Outside.material_override
	matA.set_shader_param("texture_albedo", texA)
	$Viewport.size = get_viewport().size
	
	player_cam = get_node("../../../Steve/Head/Camera")
	
	travelers_to_me = []
	
	just_started = true

func set_linked_portal(linked):
	linked_portal = linked

func update_portal_view():
	var linked_trans = linked_portal.global_transform * global_transform.inverse() * player_cam.global_transform
	var camera_to_linked_portal_dist = (player_cam.global_transform.origin - global_transform.origin).length()
	$Viewport/Camera.set_global_transform(linked_trans)
	$Viewport/Camera.set_znear(camera_to_linked_portal_dist)
	$Viewport.size = get_viewport().size

func teleport_travelers():
	for traveler in travelers_to_me:
		var trans = traveler.global_transform
		var offset = trans.origin - global_transform.origin
		
		var old_side = sign(traveler.prev_offset.dot(global_transform.basis.z))
		var new_side = sign(offset.dot(global_transform.basis.z))
		
		if old_side != new_side:
			var linked_trans = linked_portal.global_transform * global_transform.inverse() * traveler.global_transform
			traveler.set_global_transform(linked_trans)
			traveler.velocity = linked_trans.basis * traveler.velocity
			travelers_to_me.erase(traveler)
		traveler.prev_offset = offset

func _process(delta):
	if not linked_portal:
		return
	update_portal_view()
	teleport_travelers()


func _on_Area_body_entered(body):
	if just_started:
		just_started = false
		return
	
	if linked_portal and body is PortalTraveler:
		if(!travelers_to_me.has(body)):
			body.prev_offset = body.global_transform.origin - global_transform.origin
			travelers_to_me.append(body)


func _on_Area_body_exited(body):
	if(travelers_to_me.has(body)):
		travelers_to_me.erase(body)
