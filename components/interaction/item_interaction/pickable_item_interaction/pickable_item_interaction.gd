class_name PickableItemInteraction
extends Interaction

"""
Ogni interazione con un oggetto raccoglibile (PickableItemInteraction) ha un dialogo specifico che avviene quando lo si raccoglie.

Per impostarlo, non serve usare una DialogueInteraction, questa è già presente dentro la PickableItemInteraction in sé!

è sufficiente usare l'editor del PickableItemInteraction come tramite, e usare quindi la sua variabile esportata Dialalogue ID.

"""

var item_in_interaction: PickableItem

var dialogue_id: String = "Nessun dialogo"

@onready var dialogue_interaction: DialogueInteraction = $DialogueInteraction

func handle_interaction():	
	item_in_interaction.remove_from_map() #Rimuovi dalla mappa visualmente
	
	self.setup_dialogue_interaction_id()
	if self.dialogue_interaction != null: #Se voglio un certo dialogo di pick-up dell'item
		self.dialogue_interaction.handle_interaction()
	
	#Le Dialogue Boxes si sovrastano... Ora non più
	await DialogueManager.has_finished_displaying
	
	StateManager.inventory.insert(item_in_interaction)

	_remove_if_proc_only_once()
	
func _ready():
	item_in_interaction = get_parent() #Questo è l'oggetto ItemResource con cui avviene l'interazione.
	

#Non si può fare nel ready perché godot inizializza i nodi dall'ultimo al primo quindi se lo mettiamo li, ancora non ho nessun dialogue_id...
#Non c'è rischio che lo si faccia più di una volta con conseguente perdita di memoria visto che il nodo si autodistrugge dopo la prima chiamata.
func setup_dialogue_interaction_id():
	
	if self.dialogue_id == "Nessun dialogo":
		dialogue_interaction.queue_free()
		dialogue_interaction = null
	else:
		dialogue_interaction.dialogue_id = self.dialogue_id
		dialogue_interaction.minigame_requirement = self.minigame_requirement
		

