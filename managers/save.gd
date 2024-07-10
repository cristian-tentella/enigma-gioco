extends Node

"""
SaveManager

Gestisce la creazione del file json di salvataggio grazie all'array di interazioni uscite.

Per il salvataggio, servirà anche un modo per salvare gli oggetti dell'Inventory.
"""

var all_exited_interactions: Array[String] #Array che contiene tutte le interazioni uscite, quindi quelle che non devono essere ricliccate

var json = JSON.new()
var json_path = "res://addons/supabase/SaveFile/salvataggio.json"

func save_current_state_into_json():
	var inventory_owned_items_names = StateManager.inventory.return_item_names() as Array[String]
	var current_minigame = StateManager.current_minigame as int
	
	var json_file = FileAccess.open(json_path, FileAccess.WRITE)
	
	var data_for_json_file = {
		"all_exited_interactions": all_exited_interactions,
		"inventory_owned_items_names": inventory_owned_items_names,
		"current_minigame": current_minigame
	}
	
	json_file.store_string(json.stringify(data_for_json_file))
	
	json_file.close()
	json_file = null
	
	
func load_game_save_from_json():
	var json_file = FileAccess.open(json_path, FileAccess.READ)
	var content = json.parse_string(json_file.get_as_text())
	
	var inventory = StateManager.inventory












