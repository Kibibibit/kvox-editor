extends Node

const icon_size: int = 16

var place: AtlasTexture = AtlasTexture.new()
var hammer: AtlasTexture = AtlasTexture.new()
var brush: AtlasTexture = AtlasTexture.new()
var wand: AtlasTexture = AtlasTexture.new()
var pencil: AtlasTexture = AtlasTexture.new()
var eraser: AtlasTexture = AtlasTexture.new()
var bucket: AtlasTexture = AtlasTexture.new()
var gear: AtlasTexture = AtlasTexture.new()
var add: AtlasTexture = AtlasTexture.new()
var bin: AtlasTexture = AtlasTexture.new()
var extrude: AtlasTexture = AtlasTexture.new()
var eyedropper: AtlasTexture = AtlasTexture.new()

var _mapping = [
	place,hammer,brush,wand,pencil,eraser,bucket,gear,add,bin, extrude, eyedropper
]

var _atlas = preload("res://assets/icon_sheet.png")

func _ready():
	for i in _mapping.size():
		var tex: AtlasTexture = _mapping[i]
		_set_atlas(tex, i)

func _pos_from_index(index: int) -> Vector2i:
	var size: Vector2i = _atlas.get_size()/icon_size
	var x: int = index % size.x
	var y: int = floor((index-x) / (size.y as float))
	return Vector2i(x*icon_size,y*icon_size)

func _rect_from_index(index:int) -> Rect2i:
	var pos: Vector2i = _pos_from_index(index)
	return Rect2i(pos.x,pos.y,icon_size,icon_size)

func _set_atlas(texture: AtlasTexture, index: int) -> void:
	texture.atlas = _atlas
	texture.region = _rect_from_index(index)
