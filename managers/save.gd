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


"""
DIZIONARIO STATICO (lo è per definizione di utilizzo, godot non lo fa statico...) PER DEFINIRE QUANDO UN MINIGAME E' CONSIDERATO COMPLETATO
"""
var minigame_to_current_minigame_requirement = {
	"minigame_1" : 4 #Il minigame_1 è completato con current_minigame == 4, che è quando becchi la combinazione di chiavi
}

const loading_screen_step = 1 #Il loading screen va avanti di n in n per ogni nodo del save

var all_exited_interactions: Array #Array che contiene tutte le interazioni uscite, quindi quelle che non devono essere ricliccate

var json = JSON.new()
var json_path = "user://save.json"
var is_connected_to_internet: bool
var user_file = "user://user.auth"
var player_id

func _ready():
	if not AuthenticationManager.is_enabled:
		return
	Supabase.database.error.connect(on_database_query_error)
	Supabase.database.updated.connect(on_database_query_updated)
	if FileAccess.file_exists(user_file):
		player_id = get_player_id()
	
func on_database_query_error(query_result):
	print_debug("I dati non sono stati correttamente inseriti nel database" + str(query_result))

func on_database_query_updated(query_result):
	print("I dati sono stati correttamente updatati nel database" + str(query_result))


func prepare_data_to_be_saved_and_save():
	#player_id = get_player_id() #TODO: Questo mi sembra inutile?
	var inventory_owned_items_names = StateManager.inventory.return_item_names() as Array[String]
	var current_minigame = StateManager.current_minigame as int

	var data_for_json_file = {
		"all_exited_interactions": all_exited_interactions,
		"inventory_owned_items_names": inventory_owned_items_names,
		"current_minigame": current_minigame
	}
	
	var into_json = json.stringify(data_for_json_file)
	
	save_current_state_into_json(data_for_json_file)
	
	
func save_current_state_into_json(data_for_json_file):
	var json_file = FileAccess.open(json_path, FileAccess.WRITE)
	var into_json = json.stringify(data_for_json_file)
	json_file.store_string(into_json)
	
	if AuthenticationManager.is_enabled:
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
	ping_internet_check.request("https://www.google.com")
	var completed = await ping_internet_check.request_completed
	if completed[1] == 200:
		return true
	return false


#Quando lo chiama, viene chiamato anche il loading screen, quindi modificarne le values funziona anche sulla UI
#Il fatto che viene spawnato è gestito dal fatto che quando clicchi su "Play Game" si carica il salvataggio
func load_game_save_from_json():
	await get_tree().create_timer(0.0001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...
	if await is_online() and player_id != null:
		await retrieve_save_file_from_database_and_write_it_to_filesystem()
		#Se questo va a buon fine, il caricamento è al 25%
	
	if FileAccess.file_exists(json_path):
		
		var json_file = FileAccess.open(json_path, FileAccess.READ)
		var content = json.parse_string(json_file.get_as_text())
		#Barra di caricamento a 0
		UIManager.loading_screen.set_value(30)
		await get_tree().create_timer(0.0001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...
		if content == null or not content.has("all_exited_interactions") or not content.has("inventory_owned_items_names") or not content.has("current_minigame"):
			print_debug("Save file not well made, missing parts. Proceeding with no save loaded, no errors.")
			return
		StateManager.current_minigame = content.get("current_minigame")
		all_exited_interactions = content.get("all_exited_interactions") as Array #Setup per il successivo salvataggio
		#Barra di caricamento a 0
		UIManager.loading_screen.set_value(35)
		await get_tree().create_timer(0.0001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...
		var root_node = self.get_tree().root
		var all_nodes = self.get_all_children(root_node)
		#Barra di caricamento a 0
		UIManager.loading_screen.set_value(45)
		await get_tree().create_timer(0.0001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...
		#Elimina le interazioni che già sono state fatte, e ottieni la lista dei nodi pickableItems nel mentre
		var pickableItemInteraction_nodes = self.delete_interaction_nodes_from_node_list_with_name_into_name_list_and_return_item_nodes(all_nodes, all_exited_interactions)
		var inventory_owned_items_names = content.get("inventory_owned_items_names")
		#Carica nell'inventario questi nodi
		self.insert_into_inventory_from_item_names(pickableItemInteraction_nodes, inventory_owned_items_names)
		#Barra di caricamento ha incrementato li dentro piano piano fino a 80% o qualcosa di meno
		UIManager.loading_screen.set_value(90)
		await get_tree().create_timer(0.0001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...


func retrieve_save_file_from_database_and_write_it_to_filesystem():
	#Barra di caricamento a 0
	UIManager.loading_screen.set_value(5)
	await get_tree().create_timer(0.0001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...
	var query = SupabaseQuery.new().from("Users").eq("id", player_id).select(["save_file"])
	#Barra di caricamento a 0
	UIManager.loading_screen.set_value(10)
	await get_tree().create_timer(0.0001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...
	Supabase.database.query(query)
	var data = await Supabase.database.selected
	#Barra di caricamento a 0
	UIManager.loading_screen.set_value(15)
	await get_tree().create_timer(0.0001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...
	data = data[0]["save_file"]
	#Barra di caricamento a 0
	UIManager.loading_screen.set_value(20)
	await get_tree().create_timer(0.0001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...
	save_current_state_into_json(data)
	#Barra di caricamento a 0
	UIManager.loading_screen.set_value(25)
	await get_tree().create_timer(0.0001).timeout #Altrimenti rischiamo che non si vede il loading screen carino e piango...
	
	

	#var into_json = json.stringify(data_for_json_file)
	#json_file.store_string(into_json)


	#Adesso fai che rompe i nodi con stesso nome di all_exited_interactions
	#E fai in modo che prende i nodi degli oggetti e fa l'aggiunta all'inventario in base a quello che ho nel json
	#Magari fai tipo un confronto della path verso il nodo, e per l'inventario chiama manualmente l'aggiunta all'inv


func get_player_id() -> String: 
		var encrypted_file_with_user_data = FileAccess.open_encrypted_with_pass(user_file, FileAccess.READ, Supabase.config.supabaseKey)
		var user_data = JSON.parse_string(encrypted_file_with_user_data.get_as_text()) 
		return user_data.get("player_id")
	

#Funzione di supporto per ottenere tutti i nodi del gioco
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
	var all_minigame_nodes = {}
	var root_node = self.get_tree().root
	
	for node in node_list:
		
		#Controllo se il nodo è un minigame, se si, poi controllo se va rimosso totalmente chiamando la funzione a fine metodo
		var node_script = node.get_script()
		if node_script != null:
			var node_script_path = node_script.get_path()
			if node_script_path.begins_with("res://game/minigames/"):
				var key = node_script_path.substr(21, 10) #minigame_1 ad esempio. Il parsing funziona
				if all_minigame_nodes.has(key):
					all_minigame_nodes[key].append(node) #Aggiungo alla lista se c'è già
				else:
					all_minigame_nodes[key] = [node] #Se non c'è la chiave, creo la lista
				continue
		node_script = null
		
		#è un if molto lungo
		if node is Interaction:
			self._increment_loading_screen_by_value_to_a_cap_of_80_percent(loading_screen_step)
			if node is ContainerInteraction:
				var container = node.get_parent()
				var is_it_locked = container.is_locked
				if is_it_locked:
					var path_to_node = root_node.get_path_to(container) as String
					if(path_to_node in name_list):
						container.unlock_unchange_status()
					
			#Rompi le interazioni che si devono rompere in base al current_minigame. Non gli oggetti, che non dovrebbero averlo neanche questo parametro
			if not node is PickableItemInteraction and node.destroy_after_minigame_requirement_number > node.minigame_requirement and node.destroy_after_minigame_requirement_number <= StateManager.current_minigame: #Va rotto
				node.queue_free()
				node = null
			
			#Se ho un pickableItemInteraction lo returno alla fine in lista, per efficienza di popolazione inventario
			if node is PickableItemInteraction:
				pickableItemInteraction_nodes.append(node)
				continue
			
			var path_to_node = root_node.get_path_to(node) as String
			if(path_to_node in name_list):
				node.queue_free()
				node = null
	
	self.delete_minigames_that_have_been_completed(all_minigame_nodes)
	return pickableItemInteraction_nodes

#Funzione che dato un elenco di nodi PickableItemInteraction, esegue l'inserimento nell'inventario di quelli il cui nome
#sta tra items_names
func insert_into_inventory_from_item_names(item_nodes: Array, items_names: Array):
	for item in item_nodes:
		var current_item_name = item.item_in_interaction.item_name
		if current_item_name in items_names:
			item.just_insert_in_inventory()
			self._increment_loading_screen_by_value_to_a_cap_of_80_percent(loading_screen_step)
		
   
func delete_minigames_that_have_been_completed(all_minigame_dict: Dictionary):
	#Struttura dizionario: {"minigame_1": Minigame1KeyCombination:<Node2D#65380813108> , ...}
	var curr_minigame = StateManager.current_minigame
	for minigame_number in all_minigame_dict:
		var destroy_requirement = minigame_to_current_minigame_requirement["minigame_1"] #Prendo il requirement dal dict delle var di classe
		if destroy_requirement <= curr_minigame: #Va rotto
			for minigame_node in all_minigame_dict[minigame_number]:
				self._increment_loading_screen_by_value_to_a_cap_of_80_percent(loading_screen_step)
				minigame_node.queue_free()

#Questo qua purtroppo si vede solo se il caricamento è lento, credo...
#Non riesco a inserire un delay artificiale ngl
func _increment_loading_screen_by_value_to_a_cap_of_80_percent(val: int):
	var curr_value = UIManager.loading_screen.progress_bar.value
	curr_value += val
	if (curr_value >= 80): #Ho sforato o sono ad 80
		UIManager.loading_screen.set_value(80)
	else:
		UIManager.loading_screen.add_to_value(val)
