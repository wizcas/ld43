extends Node2D

var _map

#const POSSIBILITIES = {

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func map():
	if _map == null:
		_map = $TileMap
	return _map

func clear():
	map().clear()

func gen(distance):
	