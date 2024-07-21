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

@onready var riparla_con_daniel_dialogue: DialogueInteraction = $"2_riparla_con_daniel"

func talk_with_daniel_then_fade_into_oblivion():
	#Fai partire ultimo dialogo in cui alla fine dice ce la faranno i nostri eroi
	riparla_con_daniel_dialogue.handle_interaction()
	await DialogueManager.has_finished_displaying
	
	var whole_game_fade_out = create_tween()
	var player_fade_out = create_tween()
	player_fade_out.tween_property(StateManager.player, "modulate", Color.hex(0x000000), 4)
	whole_game_fade_out.tween_property(StateManager.house, "modulate", Color.hex(0x000000), 4)
	
	await whole_game_fade_out.finished
	await player_fade_out.finished
	
	await get_tree().create_timer(2).timeout
	#Esci dal gioco forzatamente
	GameManager.exit()
