extends Node


var is_game_paused = false
var is_inventory_open = false
var is_dialogue_box_shown = false


func should_player_be_able_to_move():
	return not (is_game_paused or is_inventory_open or is_dialogue_box_shown)
