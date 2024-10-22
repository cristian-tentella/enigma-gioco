"""
SUPERCLASS OF EVERY INTERACTION

Here are the extra infos you are looking for!
Da qui in poi scrivo in italiano, prima ho scritto in inglese perché faceva più figo.

###################################################################################
Ogni tipo di interazione va inserita nella cartella "interaction", e deve avere una sua specifica cartella del tipo myInteractionName_interaction.
Una volta fatto, ogni cartella ha come minimo la sua scena myInteractionName_interaction.tscn e il suo script myInteractionName_interaction.gd
Dentro myInteractionName_interaction.gd , bisogna gestire il tipo di interazione che si vuole con la funziona handle_interaction().
Se non ci sta, viene lanciato l'errore!

Se la tua interazione è stata gestita con una funzione con un nome diverso, cerca di risolvere nell'ambito del tuo script piuttosto che qui dentro, se possibile <3

METTI ASSOLUTAMENTE _remove_if_proc_only_once() ALLA FINE!!!
METTI ASSOLUTAMENTE _increment_current_minigame_if_told_so() ALLA FINE!!!


###################################################################################

TUTORIAL ->
scheletro per scrivere bene le classi interazione:
__________________________________________________

class_name XXXXXInteraction
extends Interaction

@export var quello_che_ti_serve: tipo_che_ti_serve

func handle_interaction():
	# Interaction logic
	_remove_if_proc_only_once()
	_increment_current_minigame_if_told_so()

"""

class_name Interaction
extends Area2D

@export var minigame_requirement : int = 0 # L'interazione sarà disponibile quando ti trovi su quel minigame O SUPERIORE

@export var destroy_after_minigame_requirement_number: int = -1 #Se provo a interagire con questa interazione una volta superato questo requirement, fa queue_free()
@export var just_proc_once : bool = true #Se voglio che l'interazione ci sia una volta sola in tutto il gioco
@export var increments_current_minigame: bool = false

func _ready():
	if destroy_after_minigame_requirement_number > minigame_requirement: #Se è intended che si rompe dopo tot step
		just_proc_once = false


#Abstract method for handing interactions.
#The fact that this has to be overwritten is enforced by throwing an error otherwise
func handle_interaction():
	# Throw an error if this method is not overwritten
	push_error("Method 'interact' must be overwritten in EVERY subclass. Check interaction/interaction.gd for extra infos")

#Pure debugging
func _exit_tree():
	#print_debug(get_name()+" exiting!\n")
	pass

func _remove_if_proc_only_once():
	if just_proc_once: #Se deve proccare una volta sola, detto fatto, adios!
		forcefully_remove_as_if_proc_only_once()


func _insert_into_minigameManager_dictionary():
	var node_name = self.get_name()
	if node_name != "ItemInteraction": #Per questo ci pensa l'Inventory
		var path_to_node = self.get_tree().root.get_path_to(self) as String #Path da root a nodo
		path_to_node = SaveManager.insert_house_in_path(path_to_node)
		SaveManager.all_exited_interactions.append(path_to_node)


func _increment_current_minigame_if_told_so():
	if increments_current_minigame:
		StateManager.current_minigame += 1
		increments_current_minigame = false
		print(StateManager.current_minigame)

#Funzione utile per quei casi in cui si dovrebbe rompere l'interazione guardandola ma se ci riclicchi sopra senza girarti si scassa tutto il gioco...
#Quindi lo togliamo a mano
func forcefully_remove_as_if_proc_only_once():
	#Per il salvataggio ----------
	#Non salvo nell'array le interazioni degli item, per quello basta l'inventario
	self._insert_into_minigameManager_dictionary()
	#Free normale
	self.queue_free()

