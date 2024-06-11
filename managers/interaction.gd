"""
InteractionManager


"""


extends Node


func handle_interaction(interaction: Interaction):
	if interaction is ContainerInteraction:
		handle_container_interaction(interaction)
	elif interaction is DialogueInteraction:
		handle_dialogue_interaction(interaction)


func handle_container_interaction(container_interaction: ContainerInteraction):
	if container_interaction.animated_sprite.animation == container_interaction.open_animation:
		container_interaction.animated_sprite.animation = container_interaction.close_animation
	else:
		container_interaction.animated_sprite.animation = container_interaction.open_animation


func handle_dialogue_interaction(dialogue_interaction: DialogueInteraction):
	DialogueManager.handle_dialogue_interaction(dialogue_interaction)
