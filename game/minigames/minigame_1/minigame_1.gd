extends Node

"""
Sei spawnato nella camera da letto, quindi ti trovi già li.

Obbiettivo: Aprire porta camera da letto

Stanze Accessibili: Camera da Letto, Balcone

Oggetti che servono:
	set_of_keys (aprire camera da letto)

Step di attivazione minigame:
	- Trovate set_of_keys sotto lo sdraio in balcone
	- Provare ad aprire camera da letto con quelle chiavi 
	  (nessuna funziona)
	- Minigame inizia con beccare la combo di tre chiavi giuste.
	  Magari dopo il primo tentativo sbagliato si locka il minigame
	  e dice tipo "dovrei guardare in giro, magari c'è qualche indizio"

Step di risoluzione minigame:
	- Interazione col poster col pi greco
	- Torna alla porta e ora il minigame funziona e può fare tentativi

"""

var keys_order = "314"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
