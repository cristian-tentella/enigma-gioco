extends Node

"""
SaveManager

Gestisce la creazione del file json di salvataggio grazie all'array di interazioni uscite.

Per il salvataggio, servirà anche un modo per salvare gli oggetti dell'Inventory.
"""

var all_exited_interactions: Array #Array che contiene tutte le interazioni uscite, quindi quelle che non devono essere ricliccate

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
	
	var into_json = json.stringify(data_for_json_file)
	json_file.store_string(into_json)
	print(into_json)
	json_file.close()
	json_file = null
	


#StateManager.inventory_UI = inventory_UI #Settati nel SaveManager
#StateManager.inventory = inventory_UI.inv #Settati nel SaveManager
#StateManager.current_minigame = ?
#self.all_exited_interactions = ?
#StateManager.inventory_UI.inv = ?
func load_game_save_from_json():
	var json_file = FileAccess.open(json_path, FileAccess.READ)
	var content = json.parse_string(json_file.get_as_text())
	
	if content == null:
		return
	
	if content.has("all_exited_interactions"):
		all_exited_interactions = content.get("all_exited_interactions") as Array #Setup per il successivo salvataggio
		var root_node = self.get_tree().root
		var all_nodes = self.get_all_children(root_node)
		self.delete_interaction_nodes_from_node_list_with_name_into_name_list(all_nodes, all_exited_interactions)

	if content.has("current_minigame"):
		StateManager.current_minigame = content.get("current_minigame")
	
	


	#Adesso fai che rompe i nodi con stesso nome di all_exited_interactions
	#E fai in modo che prende i nodi degli oggetti e fa l'aggiunta all'inventario in base a quello che ho nel json
	#Magari fai tipo un confronto della path verso il nodo, e per l'inventario chiama manualmente l'aggiunta all'inv

func get_all_children(node: Node) -> Array:
	var children = []
	_get_all_children_recursive(node, children)
	return children

func _get_all_children_recursive(node: Node, children: Array):
	for child in node.get_children():
		children.append(child)
		_get_all_children_recursive(child, children)

func delete_interaction_nodes_from_node_list_with_name_into_name_list(node_list: Array, name_list: Array):
	var root_node = self.get_tree().root
	for node in node_list:
		if node is Interaction:
			var path_to_node = root_node.get_path_to(node) as String
			if(path_to_node in name_list):
				node.queue_free()








