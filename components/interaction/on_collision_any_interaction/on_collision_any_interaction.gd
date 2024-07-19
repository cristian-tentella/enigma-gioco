class_name OnCollisionAnyInteraction
extends Interaction

@export var script_path: String = "res://components/interaction/on_collision_any_interaction/scripts_dump/anything.gd"
@export var method_name: String = "method_of_interaction"
@export var is_method_in_direct_parent: bool = false

"""
Classe che gestisce interazioni forzate appena il giocatore ci entra dentro.

L'interazione parte in funzione dello script che è attached sul nodo OnCollisionAnyInteraction.
TUTORIAL COME USARE:
	
	] Mettere on_collision_any_interaction.tscn dentro house
	] Mettere figlio un CollisionShape2D che rappresenta il punto dove, se il player entra, l'interazione parte
	] Crea uno script con la funzione che vuoi associare.
	  Lo script mettilo in un posto sensato, se hai dubbi, mettilo dentro res://components/interaction/on_collision_any_interaction/scripts_dump/
	  Una volta fatto, copia il path verso lo script e mettilo dentro la variabile esportata script_path
	  La funzione che chiami deve essere definita come static, e il suo nome deve essere messo nella variabile esportata
	
	  TIP: se lo script lo chiami interazione_per_dialogo_daniel.gd, magari chiamaci anche il nodo della scena corrispondente per pura leggibilità.
	
	] Dentro this_is_the_interaction, fai quello che vuoi. La variabile "variable" può essere di qualsiasi tipo, se hai bisogno di tante info per l'interazione,
	  usa magari una lista.
"""

#TODO: Se necessario, implementare che una volta che si procca una certa interazione, la stessa area può proccare altro
#Magari un contatore che dice a che interazione sei, e nella funzione statica associata tipo:
# if interaction_counter == 1:
#	 interazione_1()
# if interaction_counter == 2:
#	interazione_2()
# if interaction_counter == 3:
#	self.queue_free() -> questo controllo meglio farlo dentro handle_interaction() qui dentro, magari con una var esportata!


var class_resource

func _ready():
	if is_method_in_direct_parent:
		class_resource = null
		return
	
	class_resource = ResourceLoader.load(script_path)
	
	if class_resource == null: #Print per capire cosa si ha sbagliato
		print_debug("\n\tERROR: OnCollisionAnyInteraction node named ["+get_name()+"] is using a wrong script_path!\n")
		return

#Quando entro in collisione, attivo questa funzione
func handle_interaction():
	if is_method_in_direct_parent: #Modo per non usare metodi statici, chiamare funzioni definite nel padre diretto!
		self.get_parent().call(method_name)
	else:
		if class_resource.has_method(method_name): #Controllo se il metodo è giusto
			class_resource.call(method_name) #Chiamo il metodo che mi serve
		else: #Print per capire cosa si ha sbagliato
			print_debug("\n\tERROR: OnCollisionAnyInteraction node named [" + get_name() + "] is using a wrong method_name OR THE METHOD IS NOT STATIC, not executing anything!\n")
	
	_remove_if_proc_only_once()
	_increment_current_minigame_if_told_so()

