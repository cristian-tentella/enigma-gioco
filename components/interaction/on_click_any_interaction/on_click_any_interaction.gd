class_name OnClickAnyInteraction
extends Interaction

@export var script_path: String = "res://components/interaction/on_collision_any_interaction/scripts_dump/anything.gd"
@export var method_name: String = "method_of_interaction"
 
"""
Classe che gestisce interazioni forzate appena il giocatore ci entra dentro.

L'interazione parte in funzione dello script che è attached sul nodo OnCollisionAnyInteraction.
TUTORIAL COME USARE:
	
	] Mettere on_collision_any_interaction.tscn dentro house
	] Mettere figlio un CollisionShape2D che rappresenta il punto dove, se il player entra, l'interazione parte
	] Crea uno script con la funzione che vuoi associare.
	  Lo script mettilo in un posto sensato, se hai dubbi, mettilo dentro res://components/interaction/on_click_any_interaction/scripts_dump/
	  Una volta fatto, copia il path verso lo script e mettilo dentro la variabile esportata script_path
	  La funzione che chiami deve essere definita come static, e il suo nome deve essere messo nella variabile esportata
	
	  TIP: se lo script lo chiami interazione_per_dialogo_daniel.gd, magari chiamaci anche il nodo della scena corrispondente per pura leggibilità.
	
	] Dentro this_is_the_interaction, fai quello che vuoi. La variabile "variable" può essere di qualsiasi tipo, se hai bisogno di tante info per l'interazione,
	  usa magari una lista.
"""
var class_resource

func _ready():
	class_resource = ResourceLoader.load(script_path)
	
	if class_resource == null:
		print_debug("\n\tERROR: OnCollisionAnyInteraction node named ["+get_name()+"] is using a wrong script_path! Interacting WILL crash everything\n")
		return


func handle_interaction():
	if class_resource.has_method(method_name):
		class_resource.call(method_name)
	else:
		print_debug("\n\tERROR: OnCollisionAnyInteraction node named [" + get_name() + "] is using a wrong method_name OR THE METHOD IS NOT STATIC, not executing anything!\n")


