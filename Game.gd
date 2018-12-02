extends Node2D

signal game_over
signal victory

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_World_game_over():
	emit_signal('game_over')


func _on_World_victory():
	emit_signal('victory')
