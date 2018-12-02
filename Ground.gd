extends Node2D

export (int) var surface_y = 5
export (int) var distance = 20
export (int) var neg_length = 10
export (int) var height = 5

onready var _map = $TileMap
var tiles
var cur_x

const SURFACE_TILE_START = 0
const SURFACE_TILE_COUNT = 4
const BENEATH_TILE_START = 4
const BENEATH_TILE_COUNT = 10

enum TileType {
	Surface,
	Beneath
}

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	cur_x = 0

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func meter():
	return map().cell_size.x

func map():
	if _map == null:
		_map = $TileMap
	return _map
	
func clear():
	map().clear()

func surface_world_y():
	return map().map_to_world(Vector2(0, surface_y + 1))

func _rnd_tile_idx(tiletype):
	var start = 0
	var tiles_count = map().tile_set.get_tiles_ids().size()
	var size = tiles_count
	if tiletype == TileType.Surface:
		start = SURFACE_TILE_START
		size = SURFACE_TILE_COUNT
	elif tiletype == TileType.Beneath:
		start = BENEATH_TILE_START
		size = BENEATH_TILE_COUNT
		
	var rnd = start + randi() % size
	return min(rnd, tiles_count)
	
func gen(cell_count):
	clear()
	for x in range(cell_count):
		for y in range(height):
			map().set_cell(cur_x, surface_y + y, _rnd_tile_idx(TileType.Surface if y == 0 else TileType.Beneath))
		cur_x += 1
	for x in range(neg_length):
		for y in range(height):
			map().set_cell(-1-x, surface_y + y, _rnd_tile_idx(TileType.Surface if y == 0 else TileType.Beneath))
