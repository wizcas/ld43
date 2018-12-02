extends CanvasLayer

export (PackedScene) var servant_card_gen

onready var servant_root = $Bg/MarginContainer/Groups/Left/ServantList
onready var card_mark = $Bg/MarginContainer/Groups/Left/ServantList/Mark
var servant_cards = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	for card in servant_root.get_children():
		if card != card_mark:
			card.free()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Team_size_changed(team, size, tail):
	var new_servants = []
	var updated_cards = []
	for servant in team.servants:
		# Look for matching servant cards
		# Create if not found
		var found = false
		for i in servant_cards.size():
			var card = servant_cards[i]
			if card.servant == servant:
				servant_cards.remove(i)
				updated_cards.append(card)
				found = true
				break
		if not found:
			new_servants.append(servant)
	# delete dead servants
	for card in servant_cards:
		delete_card(card)
	# make new cards
	for servant in new_servants:
		updated_cards.append(make_card(servant))
	
	servant_cards = updated_cards
		
func make_card(servant):
	var ui = servant_card_gen.instance()
	ui.servant = servant
	servant_root.add_child_below_node(card_mark, ui)
	return {
		'ui': ui,
		'servant': servant,
		}
	
func delete_card(card):
	if card == null:
		return
	card.ui.queue_free()