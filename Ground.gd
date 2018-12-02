extends Node2D

export (int) var surface_y = 5
export (int) var distance = 100
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
	tiles = _map.tile_set.get_tiles_ids()
	cur_x = 0
	
	gen(distance)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func surface_world_y():
	return _map.map_to_world(Vector2(0, surface_y+6))

func _rnd_tile_idx(tiletype):
	var start = 0
	var size = tiles.size()
	if tiletype == TileType.Surface:
		start = SURFACE_TILE_START
		size = SURFACE_TILE_COUNT
	elif tiletype == TileType.Beneath:
		start = BENEATH_TILE_START
		size = BENEATH_TILE_COUNT
		
	return start + randi() % size
	
func gen(cell_count):
	for x in range(cell_count):
		for y in range(height):
			_map.set_cell(cur_x, surface_y + y, _rnd_tile_idx(TileType.Surface if y == 0 else TileType.Beneath))
		cur_x += 1
	for x in range(neg_length):
		for y in range(height):
			_map.set_cell(-1-x, surface_y + y, _rnd_tile_idx(TileType.Surface if y == 0 else TileType.Beneath))
