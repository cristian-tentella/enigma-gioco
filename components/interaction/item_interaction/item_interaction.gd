class_name ItemInteraction
extends Interaction

var item_in_interaction: GenericItem

func handle_interaction():
	item_in_interaction = get_parent() #Questo è l'oggetto ItemResource con cui avviene l'interazione.
	print(item_in_interaction.collision_circle_radius)
	
	"""
	Probabilmente qui ci andrà una cosa tipo StateManager.inventory.add(item_that_is_in_the_interaction)
	"""
