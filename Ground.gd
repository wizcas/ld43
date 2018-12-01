extends Node2D

export (int) var surface_y = 4
export (int) var distance = 100
export (int) var neg_length = 10
export (int) var height = 5

onready var _map = $TileMap
var tiles
var cur_x

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


func _rnd_tile_idx():
	return randi() % tiles.size()
	
func gen(cell_count):
	for x in range(cell_count):
		for y in range(height):
			_map.set_cell(cur_x, surface_y + y, _rnd_tile_idx())
		cur_x += 1
	for x in range(neg_length):
		for y in range(height):
			_map.set_cell(-1-x, surface_y + y, _rnd_tile_idx())
		