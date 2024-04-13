class_name InteractionHandler
extends Node


func handle_interaction(interaction: Interaction):
	if interaction is DialogueInteraction:
		handle_dialogue_interaction(interaction)


func handle_dialogue_interaction(dialogue_interaction: DialogueInteraction):
	DialogueManager.show_dialogue_balloon(dialogue_interaction.dialogue_resource, dialogue_interaction.title)
