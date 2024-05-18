class_name InteractionHandler
extends Node


func handle_interaction(interaction: Interaction):
	if interaction is ContainerInteraction:
		handle_container_interaction(interaction)
	elif interaction is DialogueInteraction:
		handle_dialogue_interaction(interaction)


func handle_container_interaction(interaction: ContainerInteraction):
	if interaction.animated_sprite.animation == interaction.open_animation:
		interaction.animated_sprite.animation = interaction.close_animation
	else:
		interaction.animated_sprite.animation = interaction.open_animation


func handle_dialogue_interaction(interaction: DialogueInteraction):
	DialogueManager.process_dialogue_interaction(interaction)
