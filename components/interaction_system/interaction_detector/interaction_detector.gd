class_name InteractionDetector
extends Area2D


const interaction_handler_script = preload("res://components/interaction_system/interaction_handler/interaction_handler.gd")

@onready var interactions: Array[Interaction]
@onready var interaction_handler = interaction_handler_script.new()


func activate_closest_interaction():
	if interactions.is_empty():
		return
	interaction_handler.handle_interaction(find_closest_interaction())


func _on_area_entered(area: Area2D):
	if area is Interaction:
		interactions.append(area)
		


func _on_area_exited(area: Area2D):
	if area is Interaction:
		interactions.erase(area)


func find_closest_interaction():
	var closest_interaction = interactions[0]

	for interaction in interactions:
		var current_shortest_distance = distance_to_interaction(closest_interaction)
		if distance_to_interaction(interaction) < current_shortest_distance:
			closest_interaction = interaction

	return closest_interaction


func distance_to_interaction(interaction: Interaction) -> float:
	return global_position.distance_to(interaction.global_position)
