class_name Minigame5TrovaListaInvitati
extends Node
"""
PARLA PRIMA CON DANIEL (current_minigame = 11 (+1)) E POI PUO' INTERAGIRE CON LA SPADA

FLOW:
	Parlo con daniel alla porta
	Prendo lista invitati dal tavolo
	Riparlo con daniel alla porta e il gioco finisce

Obbiettivo: Adios

Step di attivazione minigame:
	Nessuno

"""


"""
FLOW:
	Parli con daniel prima volta: current minigame += 1 (17)
	Prendi le chiavi
	Riparli con daniel

"""

"""
NODI NECESSARI PER FUNZIONAMENTO:
	
	lista_degli_invitati dentro house.tscn (dentro studio) (minigame requirement: 17, dialogue id: pickup_guest_list)
	
"""


