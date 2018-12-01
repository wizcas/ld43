extends Node2D

export (int) var surface_y = 4
export (int) var buf_size = 20

onready var _map = $TileMap
var tiles
var cur_x

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	tiles = _map.tile_set.get_tiles_ids()
	cur_x = 0
	
	_gen_distance(buf_size)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _rnd_tile_idx():
	return randi() % tiles.size()
	
func _gen_distance(cell_count):
	for i in range(cell_count):
		_map.set_cell(cur_x, surface_y, _rnd_tile_idx())
		cur_x += 1
		