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
###################################################################################

TUTORIAL ->
scheletro per scrivere bene le classi interazione:
__________________________________________________

class_name XXXXXInteraction
extends Interaction

@export var quello_che_ti_serve: tipo_che_ti_serve

func handle_interaction():
	pass
"""

class_name Interaction
extends Area2D

#Abstract method for handing interactions.
#The fact that this has to be overwritten is enforced by throwing an error otherwise
func handle_interaction():
	# Throw an error if this method is not overwritten
	push_error("Method 'interact' must be overwritten in EVERY subclass. Check interaction/interaction.gd for extra infos")
