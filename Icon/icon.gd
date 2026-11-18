@tool
extends Sprite2D
class_name Icon

var offsets: Array[int] = [11, 44, 75, 107, 139, 171]

@export_range(0, 4, 1) var index: int = 0:
	get: return index
	set(v):
		index = v
		(texture as AtlasTexture).region.position.y = offsets[index]
