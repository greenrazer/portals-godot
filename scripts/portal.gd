extends Spatial

const NEAR_CLIPPING_PLANE_OFFSET = 1

var player_cam
var linked_portal
var travelers_to_me
var intersecting_static_bodies

func _ready():
	var texA = $Viewport.get_texture()
	var matA = $Shape/Outside.material_override
	matA.set_shader_param("texture_albedo", texA)
	$Viewport.size = get_viewport().size
	
	player_cam = get_node("../../../Steve/Head/Camera")
	
	travelers_to_me = []
	intersecting_static_bodies = []

func set_linked_portal(linked):
	linked_portal = linked

func update_portal_view():
	var linked_trans = linked_portal.global_transform * global_transform.inverse() * player_cam.global_transform
	var camera_to_linked_portal_dist = (player_cam.global_transform.origin - global_transform.origin).length()
	$Viewport/Camera.set_global_transform(linked_trans)
	$Viewport/Camera.set_znear(clamp(camera_to_linked_portal_dist - NEAR_CLIPPING_PLANE_OFFSET,0.01,INF))
	$Viewport.size = get_viewport().size

func teleport_travelers():
	for traveler in travelers_to_me:
		var offset = traveler.global_transform.origin - global_transform.origin
		
		var old_side = sign(traveler.prev_offset.dot(global_transform.basis.z))
		var new_side = sign(offset.dot(global_transform.basis.z))
		
		if old_side != new_side:
			var to_linked_portal = linked_portal.global_transform * global_transform.inverse()
			traveler.global_transform = to_linked_portal * traveler.global_transform
			traveler.velocity = to_linked_portal.basis * traveler.velocity
			travelers_to_me.erase(traveler)
		traveler.prev_offset = offset

func _process(delta):
	if not linked_portal:
		return
	if $Shape/VisibilityNotifier.is_on_screen():
		update_portal_view()
	teleport_travelers()


func _on_Area_body_entered(body):
	if linked_portal and body is PortalTraveler and !travelers_to_me.has(body):
		body.prev_offset = body.global_transform.origin - global_transform.origin
		travelers_to_me.append(body)


func _on_Area_body_exited(body):
	if linked_portal and body is PortalTraveler and travelers_to_me.has(body):
		travelers_to_me.erase(body)


func _on_InPortalArea_body_entered(body):
	if linked_portal and body is PortalTraveler:
		body.in_portal_field = true
		for static_body in intersecting_static_bodies:
			static_body.get_child(0).disabled = true
	elif body is StaticBody and !intersecting_static_bodies.has(body):
		intersecting_static_bodies.append(body)


func _on_InPortalArea_body_exited(body):
	if linked_portal and body is PortalTraveler:
		body.in_portal_field = false
		for static_body in intersecting_static_bodies:
			static_body.get_child(0).disabled = false
	elif body is StaticBody and body.get_child(0).disabled == false:
		intersecting_static_bodies.erase(body)
