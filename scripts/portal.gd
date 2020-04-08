extends Node


func _ready():
	var tex = $Viewport.get_texture()#.set_flags(Texture.FLAG_CONVERT_TO_LINEAR)
	var mat = $Mesh/Outside.material_override
	mat.set_shader_param("texture_albedo", tex)
	$Viewport.size = get_viewport().size
