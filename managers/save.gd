extends Node

"""
SaveManager

Gestisce la creazione del file json di salvataggio grazie all'array di interazioni uscite.

Per il salvataggio, servirà anche un modo per salvare gli oggetti dell'Inventory.

NOTES:
	I nodi di interazione chiamali come ti pare, li gestisco con tutto il path quindi in nome non deve essere univoco
	(nella stessa scena si, ma è obbligato da editor!)
	
	Per l'inventario, si suppone che non esistano item doppioni.
	Per questo motivo NON usare due "set_of_keys" con stesso quindi item_name, altrimenti il salvataggio li
	prenderà sempre tutti insieme, ma da specifiche di gioco questo è rispettato.
"""

var all_exited_interactions: Array #Array che contiene tutte le interazioni uscite, quindi quelle che non devono essere ricliccate

var json = JSON.new()
var json_path = "user://save.json"
var is_connected_to_internet: bool
var user_file = "user://user.auth"
var player_id

func _ready():
	Supabase.database.error.connect(on_database_query_error)
	Supabase.database.updated.connect(on_database_query_updated)
	if FileAccess.file_exists(user_file):
		player_id = get_player_id()
	
func on_database_query_error(query_result):
	print_debug("I dati non sono stati correttamente inseriti nel database" + str(query_result))

func on_database_query_updated(query_result):
	print("I dati sono stati correttamente updatati nel database" + str(query_result))


func prepare_data_to_be_saved_and_save():
	player_id = get_player_id()
	var inventory_owned_items_names = StateManager.inventory.return_item_names() as Array[String]
	var current_minigame = StateManager.current_minigame as int
	var data_for_json_file = {
		"all_exited_interactions": all_exited_interactions,
		"inventory_owned_items_names": inventory_owned_items_names,
		"current_minigame": current_minigame
	}
	save_current_state_into_json(data_for_json_file)
	
	
func save_current_state_into_json(data_for_json_file):
	var json_file = FileAccess.open(json_path, FileAccess.WRITE)
	var into_json = json.stringify(data_for_json_file)
	json_file.store_string(into_json)
	save_current_state_to_online_database(data_for_json_file)
	json_file.close()
	json_file = null
	
	
func save_current_state_to_online_database(save_file: Dictionary):
	var query = SupabaseQuery.new().from("Users").eq("id", player_id).update({save_file = save_file})
	Supabase.database.query(query)


#StateManager.inventory_UI = inventory_UI #Settati nel SaveManager
#StateManager.inventory = inventory_UI.inv #Settati nel SaveManager
#StateManager.current_minigame = ?
#self.all_exited_interactions = ?
#StateManager.inventory_UI.inv = ?


	
func is_online() -> bool:
	var ping_internet_check = HTTPRequest.new()
	add_child(ping_internet_check)
	ping_internet_check.request("http://www.google.com")
	var completed = await ping_internet_check.request_completed
	if completed[1] == 200:
		return true
	return false
	
func load_game_save_from_json():
	if await is_online() and player_id != null:
		await retrieve_save_file_from_database_and_write_it_to_filesystem()
	if FileAccess.file_exists(json_path):
		var json_file = FileAccess.open(json_path, FileAccess.READ)
		var content = json.parse_string(json_file.get_as_text())
		if content == null or not content.has("all_exited_interactions") or not content.has("inventory_owned_items_names") or not content.has("current_minigame"):
			print_debug("Save file not well made, missing parts.")
			return
			
		all_exited_interactions = content.get("all_exited_interactions") as Array #Setup per il successivo salvataggio
		var root_node = self.get_tree().root
		var all_nodes = self.get_all_children(root_node)
		#Elimina le interazioni che già sono state fatte, e ottieni la lista dei nodi pickableItems nel mentre
		var pickableItemInteraction_nodes = self.delete_interaction_nodes_from_node_list_with_name_into_name_list_and_return_item_nodes(all_nodes, all_exited_interactions)
		var inventory_owned_items_names = content.get("inventory_owned_items_names")
		#Carica nell'inventario questi nodi
		self.insert_into_inventory_from_item_names(pickableItemInteraction_nodes, inventory_owned_items_names)
		
		StateManager.current_minigame = content.get("current_minigame")


func retrieve_save_file_from_database_and_write_it_to_filesystem():
	var query = SupabaseQuery.new().from("Users").eq("id", player_id).select(["save_file"])
	Supabase.database.query(query)
	var data = await Supabase.database.selected
	data = data[0]["save_file"]
	save_current_state_into_json(data)
	
	

	#var into_json = json.stringify(data_for_json_file)
	#json_file.store_string(into_json)

	#Adesso fai che rompe i nodi con stesso nome di all_exited_interactions
	#E fai in modo che prende i nodi degli oggetti e fa l'aggiunta all'inventario in base a quello che ho nel json
	#Magari fai tipo un confronto della path verso il nodo, e per l'inventario chiama manualmente l'aggiunta all'inv

#Funzione di supporto per ottenere tutti i nodi del gioco
func get_player_id() -> String: 
		var encrypted_file_with_user_data = FileAccess.open_encrypted_with_pass(user_file, FileAccess.READ, Supabase.config.supabaseKey)
		var user_data = JSON.parse_string(encrypted_file_with_user_data.get_as_text()) 
		return user_data.get("player_id")
	
	
func get_all_children(node: Node) -> Array:
	var children = []
	_get_all_children_recursive(node, children)
	return children

#Funzione di supporto alla funzione di supporto per ottenere tutti i nodi del gioco
func _get_all_children_recursive(node: Node, children: Array):
	for child in node.get_children():
		children.append(child)
		_get_all_children_recursive(child, children)

#Funzione che data una lista di nodi e un array di stringhe, elimina i nodi la cui path è presente tra quelle
#stringhe.
func delete_interaction_nodes_from_node_list_with_name_into_name_list_and_return_item_nodes(node_list: Array, name_list: Array):
	var pickableItemInteraction_nodes = []
	var root_node = self.get_tree().root
	for node in node_list:
		if node is Interaction:
			#Se ho un pickableItemInteraction lo returno alla fine in lista, per efficienza di popolazione inventario
			if node is PickableItemInteraction:
				pickableItemInteraction_nodes.append(node)
				continue
			
			var path_to_node = root_node.get_path_to(node) as String
			if(path_to_node in name_list):
				node.queue_free()
	return pickableItemInteraction_nodes

#Funzione che dato un elenco di nodi PickableItemInteraction, esegue l'inserimento nell'inventario di quelli il cui nome
#sta tra items_names
func insert_into_inventory_from_item_names(item_nodes: Array, items_names: Array):
	for item in item_nodes:
		var current_item_name = item.item_in_interaction.item_name
		if current_item_name in items_names:
			item.handle_interaction()
		




