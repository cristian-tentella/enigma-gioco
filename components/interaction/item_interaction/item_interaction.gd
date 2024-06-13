class_name ItemInteraction
extends Interaction

var item_that_is_in_the_interaction: ItemResource

func handle_interaction():
	item_that_is_in_the_interaction = get_parent().item_resource #Questo è l'oggetto ItemResource con cui avviene l'interazione.
	
	"""
	Probabilmente qui ci andrà una cosa tipo StateManager.add_to_inventory(item_that_is_in_the_interaction)
	"""
