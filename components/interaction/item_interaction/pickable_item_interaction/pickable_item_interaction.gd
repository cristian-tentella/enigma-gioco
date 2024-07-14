class_name PickableItemInteraction
extends Interaction

var item_in_interaction: PickableItem

func handle_interaction():
	item_in_interaction.remove_from_map() #Rimuovi dalla mappa le sue 
	StateManager.inventory.insert(item_in_interaction)
	#TODO: Dialogo che ti dice che hai preso un item
	
	_remove_if_proc_only_once()
	
func _ready():
	item_in_interaction = get_parent() #Questo è l'oggetto ItemResource con cui avviene l'interazione.
