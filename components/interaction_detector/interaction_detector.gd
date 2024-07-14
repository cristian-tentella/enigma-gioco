"""
Una Area2D messa davanti alla faccia del giocatore, che detecta gli altri oggetti di interazione che ci sono nella scena,
talvolta ci entrasse in contatto.

Se guardo una porta, e la porta, come Node, ha un sottonodo XXXXInteraction, che a sua volta ha sottonodo CollisionShape2D, 
allora quando il CollisionShape2D della porta entra in contatto col
CollisionShape2D dell'Interaction_Detector (definito in Player.tscn)

TUTORIAL -> L'idea per creare un oggetto con area di interazione è:
	
	Fai scena a parte per l'oggetto
		Metti come figlio un nodo XXXXInteraction
			Metti come figlio di quel nodo un nodo CollisionShape2D, e modellalo nel modo opportuno 
			(occupa gran parte della texture dell'oggetto iniziale, se non di più!)
"""

class_name InteractionDetector
extends Area2D


@onready var interactions: Array[Interaction]


func activate_closest_interaction():
	if interactions.is_empty():
		return
	InteractionManager.handle_interaction(find_closest_interaction())


func _on_area_entered(area: Area2D):
	#Se l'interazione ha un requisito di minigame più alto di quello a cui sto, non posso interagirci
	if area is Interaction:
		if area.minigame_requirement > StateManager.current_minigame:
			return
	#Se ho un'interazione che si attiva appena ci entro dentro, di tipo OnCollisionAnyInteraction, la eseguo subito e non la enqueuo (terminologie)
	if area is OnCollisionAnyInteraction: 
		area.handle_interaction()
		return
	if area is Interaction:
		interactions.append(area)


func _on_area_exited(area: Area2D):
	if area is Interaction:
		interactions.erase(area) 


func find_closest_interaction():
	var closest_interaction = interactions[0]

	for interaction in interactions:
		var current_shortest_distance = distance_to_interaction(closest_interaction)
		if distance_to_interaction(interaction) < current_shortest_distance:
			closest_interaction = interaction

	return closest_interaction


func distance_to_interaction(interaction: Interaction) -> float:
	return global_position.distance_to(interaction.global_position)
