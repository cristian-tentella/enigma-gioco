"""
Interazioni che hanno a che fare con dialoghi

USARE IL DIALOGUE MANAGER
"""

class_name DialogueInteraction
extends Interaction

@export var dialogue_id: String

func handle_interaction():
	"""DialogueManager gestisce i dialoghi"""
	DialogueManager.handle_dialogue_interaction(self)
