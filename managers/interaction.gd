"""
InteractionManager

Gestore di tutte le interazioni.
NOTE: Usiamo il polimorfismo.
	Cosa implica? La spiegazione è meglio gestita in interaction/interaction.gd
	Idea base? Interazione è una superclasse delle specifiche interazioni, di cui ogni tipo è qui elencato:
		
		container_interaction : Interazioni che hanno a che fare con Container (qualcosa che si apre/chiude)
		dialogue_interaction: 	Interazione per dialoghi
"""

extends Node

func handle_interaction(interaction: Interaction):
	interaction.handle_interaction()
