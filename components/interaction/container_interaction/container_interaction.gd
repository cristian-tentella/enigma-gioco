"""
Interazioni che hanno a che fare con Container (qualcosa che si apre/chiude)

Per ora gestisce solo animazione di apertura e chiusura, in particolare delle Door
"""

class_name ContainerInteraction
extends Interaction


@export var animated_sprite: AnimatedSprite2D
@export var open_animation: String
@export var close_animation: String
var container_involved: MyContainer #L'oggetto di tipo container su cui è stata avviata l'interazione. Ad esempio, la porta su cui clicco

#Chiamata quando viene premuta spacebar intersecando la collision shape del container con quella del player (flusso parte da "input.gd")
func handle_interaction():
	container_involved = get_parent() #Assegnazione del container. SE NON FUNZIONA E' SBAGLIATA LA STRUTTURA DELLA SCENA!
	#Ogni container deve avere ContainerInteraction come figlio diretto
	if container_involved.is_locked == false:
		_handle_open_close_animation()
	else:
		var container_unlocked_successfully = container_involved.try_to_unlock()

		AudioManager.play_door_unlock_sound_effect()
		if container_unlocked_successfully:
			AudioManager.play_success_sound_effect()
		else:
			AudioManager.play_failure_sound_effect()

func _handle_open_close_animation():
	"""Se è aperto fai animazione per chiuderlo, e viceversa"""
	if self.animated_sprite.animation == self.open_animation: #Chiudilo
		self.animated_sprite.animation = self.close_animation
		container_involved.restore_physical_collision() # Fa in modo che se è chiuso ci sia la collisione a bloccarlo
		AudioManager.play_door_close_sound_effect()
	else:
		self.animated_sprite.animation = self.open_animation
		container_involved.remove_physical_collision() # Fa in modo che se sia aperta ci puoi passare attraverso
		AudioManager.play_door_open_sound_effect()
