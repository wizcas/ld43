extends Node

export (PackedScene) var game
export (PackedScene) var game_over_w
export (PackedScene) var victory_w
export (PackedScene) var pause_w

var pause_wnd

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func start():
	var g = game.instance()
	g.get_node('HUD').connect('paused', self, 'pause')
	g.get_node('World').connect('game_over', self, 'on_game_over')
	g.get_node('World').connect('victory', self, 'on_victory')
	add_child(g)
	remove_child($Menu)
	pause_wnd = pause_w.instance()
	bind_to_menu(pause_wnd)
	pause_wnd.get_node('Resume').connect('pressed', self, 'unpause')
	
func restart():
	for child in get_children():
		child.queue_free()
	get_tree().reload_current_scene()

func pause():
	if pause_wnd != null:
		add_child(pause_wnd)

func unpause():
	if pause_wnd != null:
		remove_child(pause_wnd)
		
func on_game_over(sacrificed_count, distance):
	var g = game_over_w.instance()
	g.get_node('Data/SacrificedValue').text = str(sacrificed_count)
	g.get_node('Data/DistanceValue').text = '{0}m'.format([int(distance)])
	add_child(g)
	bind_to_menu(g)
	
func on_victory(sacrificed_count):
	var g = victory_w.instance()
	g.get_node('Data/SacrificedValue').text = str(sacrificed_count)
	add_child(g)
	bind_to_menu(g)
		
func bind_to_menu(scene):
	scene.get_node('ToMenu').connect('pressed', self, 'restart')

func _on_Start_pressed():
	start()
