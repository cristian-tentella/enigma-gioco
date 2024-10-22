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

const debug_creating_save = false #Se vuoi debuggare creazione salvataggi, questo attiva una serie di print
const debug_loading_save = true #Se vuoi debuggare caricamento salvataggi, questo attiva una serie di print
const loading_bar_enabled = true #Se non vuoi fare niente con la loading bar, mettilo a false
const start_without_any_save = false #Se vuoi partire sempre senza salvataggi. Non sovrascrive file, semplicemente returna subito

const start_without_first_scripted_interaction = false #Starta senza vederti tutta la parte iniziale
const start_with_minigame_1_finished = false #Starta con i nodi minigame 1 tolti
const start_with_minigame_2_finished = false #Starta con i nodi minigame 2 tolti
const start_with_minigame_3_finished = false #Starta con i nodi minigame 3 tolti
const start_with_minigame_2_and_3_finished = false #Starta con i nodi minigame 2 e 3 tolti

var minigame_to_current_minigame_requirement = {
	"minigame_1" : 4, #Il minigame_1 è completato con current_minigame == 4, che è quando becchi la combinazione di chiavi
	"memeory" : 10,
	"minigame_3_colors_combination": 10,
	"minigame_4_ripara_spada_laser": 16,
	"minigame_5_trova_lista_invitati": 19
}

const loading_screen_step = 1 #Il loading screen va avanti di n in n per ogni nodo del save

var all_exited_interactions: Array #Array che contiene tutte le interazioni uscite, quindi quelle che non devono essere ricliccate


var json_path = "user://save.json"
var is_connected_to_internet: bool
var user_file = "user://user.auth"
var player_id
var inventory_owned_items_names 
var current_minigame: int 
var current_language: String  
var mute_button_state: bool 
var player_position: Vector2 


func _ready():
	if not AuthenticationManager.is_enabled:
		return
	Supabase.database.error.connect(on_database_query_error)
	Supabase.database.updated.connect(on_database_query_updated)
	
	

	
	
func on_database_query_error(query_result):
	print_debug("I dati non sono stati correttamente inseriti nel database" + str(query_result))

func on_database_query_updated(query_result):
	if debug_loading_save:
		print_debug("I dati sono stati correttamente updatati nel database" + str(query_result))


func prepare_data_to_be_saved_and_save():

	if FileAccess.file_exists(user_file) and AuthenticationManager.is_enabled:
		player_id = get_player_id()
	inventory_owned_items_names = StateManager.inventory.return_item_names() as Array[String] 
	current_minigame = StateManager.current_minigame 
	current_language = StateManager.current_language 
	mute_button_state = StateManager.muted
	player_position = StateManager.player.position

	
	var data_for_json_file = {
		"all_exited_interactions": all_exited_interactions,
		"inventory_owned_items_names": inventory_owned_items_names,
		"current_minigame": current_minigame,
		"current_language": current_language,
		"mute_button_state": mute_button_state,
		"player_position": player_position
	}
	
	if debug_creating_save:
		print_debug("\nInserting this into the JSON file:\n", data_for_json_file)
	
	save_current_state_into_json(data_for_json_file)
	
	
func save_current_state_into_json(data_for_json_file):
	var json_file = FileAccess.open(json_path, FileAccess.WRITE)
	var into_json = JSON.stringify(data_for_json_file)
	json_file.store_string(into_json)
	
	if AuthenticationManager.is_enabled:
		save_current_state_to_online_database(data_for_json_file)
	
	json_file.close()
	json_file = null
	
	
func save_current_state_to_online_database(save_file: Dictionary):
	if debug_creating_save:
		print_debug("\nInserting the same into the Supabase file\n")
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
	if FileAccess.file_exists(user_file) and AuthenticationManager.is_enabled:
		player_id = get_player_id()
	if start_without_any_save:
		print_debug("\nStarting without saves as specified in save.gd constants")
		return

	if StateManager.is_online and player_id != null:
		await retrieve_save_file_from_database_and_write_it_to_filesystem()
		#Se questo va a buon fine, il caricamento è al 25%
	
	if FileAccess.file_exists(json_path):
		
		var json_file = FileAccess.open(json_path, FileAccess.READ)
		var content = JSON.parse_string(json_file.get_as_text())
		
		if start_without_first_scripted_interaction:
			content = { "all_exited_interactions": ["Game/House/Rooms/Cameretta + Terrazzo/1DominikWakesUpAndGoesToBalconyUntilDaniel/everything_launcher_collision_interaction", "Game/House/Rooms/Cameretta + Terrazzo/1DominikWakesUpAndGoesToBalconyUntilDaniel/first_dialogue_on_wake_up", "Game/House/Rooms/Cameretta + Terrazzo/1DominikWakesUpAndGoesToBalconyUntilDaniel/AUTOPILOT_da_letto_a_fuori", "Game/House/Rooms/Cameretta + Terrazzo/1DominikWakesUpAndGoesToBalconyUntilDaniel/second_dialogue_after_autopilot", "Game/House/Rooms/Cameretta + Terrazzo/1DominikWakesUpAndGoesToBalconyUntilDaniel/AUTOPILOT_da_fuori_a_dentro", "Game/House/Rooms/Cameretta + Terrazzo/1DominikWakesUpAndGoesToBalconyUntilDaniel/third_dialogue_tra_poliziotti", "Game/House/Rooms/Cameretta + Terrazzo/1DominikWakesUpAndGoesToBalconyUntilDaniel/AUTOPILOT_da_fuori_a_dentro2", "Game/House/Rooms/Cameretta + Terrazzo/1DominikWakesUpAndGoesToBalconyUntilDaniel/fourth_dialogue_con_daniel"], "current_language": "it_IT", "current_minigame": 0, "inventory_owned_items_names": [], "mute_button_state": false, "player_position": "(168.8086, 119.9803)" }
		if start_with_minigame_1_finished:
			content = {"all_exited_interactions":["Game/House/Rooms/Cameretta + Terrazzo/set_of_keys/PickableItemInteraction/DialogueInteraction","Game/House/Minigame1KeyCombination/first_dialogue_on_first_open","Game/House/Minigame1KeyCombination/first_click_on_door_after_keys_taken","Game/House/Minigame1KeyCombination/second_dialogue_on_first_open","Game/House/Rooms/Cameretta + Terrazzo/porta_camera","Game/House/Minigame1KeyCombination/combination_minigame_won"],"current_language":"it_IT","current_minigame":4,"inventory_owned_items_names":["set_of_keys"],"mute_button_state":true,"player_position":"(176.8509, 199.9232)"}
			
		if start_with_minigame_2_finished:
			content = {"all_exited_interactions":["Game/House/Rooms/Cameretta + Terrazzo/set_of_keys/PickableItemInteraction/DialogueInteraction","Game/House/Minigame1KeyCombination/first_dialogue_on_first_open","Game/House/Minigame1KeyCombination/first_click_on_door_after_keys_taken","Game/House/Minigame1KeyCombination/second_dialogue_on_first_open","Game/House/Rooms/Cameretta + Terrazzo/porta_camera","Game/House/Minigame1KeyCombination/combination_minigame_won","Game/House/Minigame2Memeory/memeory_win"],"current_language":"it_IT","current_minigame":7,"inventory_owned_items_names":["set_of_keys","polipetto"],"mute_button_state":true,"player_position":"(34.10979, 439.9523)"}
		
		if start_with_minigame_3_finished:
			content = {"all_exited_interactions":["Game/House/Rooms/Cameretta + Terrazzo/set_of_keys/PickableItemInteraction/DialogueInteraction","Game/House/Minigame1KeyCombination/first_dialogue_on_first_open","Game/House/Minigame1KeyCombination/first_click_on_door_after_keys_taken","Game/House/Minigame1KeyCombination/second_dialogue_on_first_open","Game/House/Rooms/Cameretta + Terrazzo/porta_camera","Game/House/Minigame1KeyCombination/combination_minigame_won"],"current_language":"it_IT","current_minigame":7,"inventory_owned_items_names":["set_of_keys","plutonio_radioattivo"],"mute_button_state":true,"player_position":"(408.1308, 447.1521)"}
		
		if start_with_minigame_2_and_3_finished:
			content = {"all_exited_interactions":["Game/House/Rooms/Cameretta + Terrazzo/set_of_keys/PickableItemInteraction/DialogueInteraction","Game/House/Minigame1KeyCombination/first_dialogue_on_first_open","Game/House/Minigame1KeyCombination/first_click_on_door_after_keys_taken","Game/House/Minigame1KeyCombination/second_dialogue_on_first_open","Game/House/Rooms/Cameretta + Terrazzo/porta_camera","Game/House/Minigame1KeyCombination/combination_minigame_won","Game/House/Minigame2Memeory/memeory_win"],"current_language":"it_IT","current_minigame":10,"inventory_owned_items_names":["set_of_keys","polipetto","plutonio_radioattivo"],"mute_button_state":true,"player_position":"(414.7313, 448.4962)"}
		
		
		if debug_loading_save:
			print("\nSave content file is :")
			for key in content:
				print("\n\t", key, " :")
				if content[key] is Array:
					for entry in content[key]:
						print("\t\t", entry, ",")
				else:
					print("\t\t", content[key])
			print_debug("")
		#Barra di caricamento a 0
		if loading_bar_enabled:
			UIManager.loading_screen.set_value(30)
		if content == null or not content.has("all_exited_interactions") or not content.has("inventory_owned_items_names") or not content.has("current_minigame") or not content.has("mute_button_state") or not content.has("player_position"):
			print_debug("Save file not well made, missing parts. Proceeding with no save loaded, no errors.")
			return
			
		StateManager.current_minigame = content.get("current_minigame")
		all_exited_interactions = content.get("all_exited_interactions") as Array #Setup per il successivo salvataggio
		var player_position_string = "Vector2%s" % content.get("player_position")
		StateManager.player.position =  Vector2(str_to_var(player_position_string))
		StateManager.current_language = content.get("current_language")
		LanguageManager.load_language_from_state_manager()
		UIManager.update_language_flag()
		StateManager.muted = content.get("mute_button_state")
		UIManager.pause_menu.get_node("MuteButton")._load_muted_from_state_manager()
		UIManager.update_muted_button()
		
		#else:
			#StateManager.current_language = LanguageManager.get_language()

		if loading_bar_enabled:
			UIManager.loading_screen.set_value(35)
		var root_node = self.get_tree().root
		var all_nodes = self.get_all_children(root_node)
		if loading_bar_enabled:
			UIManager.loading_screen.set_value(45)
		#Elimina le interazioni che già sono state fatte, e ottieni la lista dei nodi pickableItems nel mentre
		var pickableItemInteraction_nodes = self.delete_interaction_nodes_from_node_list_with_name_into_name_list_and_return_item_nodes(all_nodes, all_exited_interactions)
		if debug_loading_save:
			var toPrint = ""
			for item_node in pickableItemInteraction_nodes:
				toPrint += "\t"+item_node.item_in_interaction.item_name+",\n"
			print_debug("\npickableItemInteraction_nodes:\n", toPrint)
		inventory_owned_items_names = content.get("inventory_owned_items_names")
		#Carica nell'inventario questi nodi
		self.insert_into_inventory_from_item_names(pickableItemInteraction_nodes, inventory_owned_items_names)
		if loading_bar_enabled:
			#Barra di caricamento ha incrementato li dentro piano piano fino a 80% o qualcosa di meno
			UIManager.loading_screen.set_value(90)


func retrieve_save_file_from_database_and_write_it_to_filesystem():
	if loading_bar_enabled:
		UIManager.loading_screen.set_value(5)
	var query = SupabaseQuery.new().from("Users").eq("id", player_id).select(["save_file"])
	if loading_bar_enabled:
		UIManager.loading_screen.set_value(10)
	Supabase.database.query(query)
	var data = await Supabase.database.selected
	if loading_bar_enabled:
		UIManager.loading_screen.set_value(15)
	data = data[0]["save_file"]
	if loading_bar_enabled:
		UIManager.loading_screen.set_value(20)
	if data != null:
		save_current_state_into_json(data)
	if loading_bar_enabled:
		UIManager.loading_screen.set_value(25)

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
	var root_node = self.get_parent()
	assert(root_node.get_name() == "root") #Se non è cosi, allora metti save.gd negli autoload!
	
	
	for node in node_list:
		
		#Controllo se il nodo è un minigame, se si, poi controllo se va rimosso totalmente chiamando la funzione a fine metodo
		var node_script = node.get_script()
		if node_script != null:
			var node_script_path = node_script.get_path()
			if "scripted" in node_script_path:
				if debug_loading_save:
					print_debug("\n\nFOUND SCRIPT-> ", node_script_path)
			if node_script_path.begins_with("res://game/minigames/"):
				var key = node_script_path.substr(21, node_script_path.substr(21).find("/")) #minigame_1 ad esempio. Il parsing funziona
				if all_minigame_nodes.has(key):
					all_minigame_nodes[key].append(node) #Aggiungo alla lista se c'è già
				else:
					all_minigame_nodes[key] = [node] #Se non c'è la chiave, creo la lista
		
		if node is Interaction:
			var path_to_node
			path_to_node = root_node.get_path_to(node) as String
			path_to_node = insert_house_in_path(path_to_node)
			
			if loading_bar_enabled:
				self._increment_loading_screen_by_value_to_a_cap_of_80_percent(loading_screen_step)
			
			if node is ContainerInteraction:
				if debug_loading_save:
					print_debug("CONTAINER LOCKED FOUND -> ", path_to_node)
				var container = node.get_parent()
				var is_it_locked = container.is_locked
				if is_it_locked:
					path_to_node = root_node.get_path_to(container) as String
					if(path_to_node in name_list):
						print("\n\t->", path_to_node)
						print("\n\t->", name_list)
						container.unlock_unchange_status()
						if debug_loading_save:
							print_debug("CONTAINER UNLOCKED")
					elif debug_loading_save:
						print_debug("CONTAINER WAS NOT UNLOCKED")
				continue
			
			#Rompi le interazioni che si devono rompere in base al current_minigame. Non gli oggetti, che non dovrebbero averlo neanche questo parametro
			if not node is PickableItemInteraction and node.destroy_after_minigame_requirement_number > node.minigame_requirement and node.destroy_after_minigame_requirement_number <= StateManager.current_minigame: #Va rotto
				node.queue_free()
				node = null
				continue
			
			#Se ho un pickableItemInteraction lo returno alla fine in lista, per efficienza di popolazione inventario
			if node is PickableItemInteraction:
				pickableItemInteraction_nodes.append(node)
				continue
			
			
			
			if(path_to_node in name_list):
				if debug_loading_save:
					print_debug("NODE PATH IN LIST TO DELETE -> ", path_to_node)
				node.queue_free()
				node = null
			else:
				if debug_loading_save:
					print_debug("NODE PATH NOT IN LIST -> ", path_to_node)
	
	self.delete_minigames_that_have_been_completed(all_minigame_nodes)
	return pickableItemInteraction_nodes

#Praticamente quando si ricreava la House per il Logout, la path non era più con "House" ma con "@Node2D..."
#E questo rompeva tutto il save basato sulle path.
#Workaround che dovrebbe funzionare, do not touch
func insert_house_in_path(path: String) -> String:
	var node2d_index = path.find("Node2D")
	if node2d_index == -1:
		# "Node2D" is not present in the string
		return path
	
	var first_slash_index = path.find("/")
	if first_slash_index == -1:
		# No slashes found, cannot insert "House"
		return path
	
	var second_slash_index = path.find("/", first_slash_index + 1)
	if second_slash_index == -1:
		# Only one slash found, cannot insert "House"
		return path
	
	# Construct the new path with "House" inserted
	var new_path = path.substr(0, first_slash_index + 1) + "House" + path.substr(second_slash_index)
	return new_path


#Funzione che dato un elenco di nodi PickableItemInteraction, esegue l'inserimento nell'inventario di quelli il cui nome
#sta tra items_names
func insert_into_inventory_from_item_names(item_nodes: Array, items_names: Array):
	for item in item_nodes:
		var current_item_name = item.item_in_interaction.item_name
		if current_item_name in items_names:
			item.just_insert_in_inventory()
			self._increment_loading_screen_by_value_to_a_cap_of_80_percent(loading_screen_step)
		
   
func delete_minigames_that_have_been_completed(all_minigame_dict: Dictionary):
	#Struttura dizionario: { "minigame_1": { Minigame1KeyCombination:<Node2D#88063609573>: "minigame_1/minigame_1.gd", CombinationLock:<Control#94287957038>: "minigame_1/combination_lock.gd" }
	#Non è più cosi, è una lista
	var curr_minigame: int = StateManager.current_minigame
	var minigame_keys: Array = minigame_to_current_minigame_requirement.keys()
	var iteraction_index: int = 0

	for minigame_key_from_input in all_minigame_dict: #Sto su minigame_1 dell'input
		
			var minigame_key = minigame_keys[iteraction_index]
			iteraction_index += 1
			
			"""
			Metti dentro house.tscn LE SCENE DEI MINIGIOCHI IN ORDINE
			- Dall'alto verso il basso i minigiochi nello STESSO ordine in cui si trovano dentro 
			  self.minigame_to_current_minigame_requirement
			"""
			
			assert(minigame_key_from_input == minigame_key)
			if debug_loading_save:
				print_debug("THINKING OF DELETING NODES OF MINIGAME -> ", minigame_key_from_input)
			var destroy_requirement = minigame_to_current_minigame_requirement[minigame_key] #Prendo il requirement dal dict delle var di classe
			if destroy_requirement <= curr_minigame: #Vanno rotti tutti quei nodi
				if debug_loading_save:
					print_debug("DELETING NODES OF MINIGAME -> ", minigame_key_from_input)
				for minigame_node in all_minigame_dict[minigame_key_from_input]: #Iterazione su lista input per rompere i nodi
					if loading_bar_enabled:
						self._increment_loading_screen_by_value_to_a_cap_of_80_percent(loading_screen_step)
					if debug_loading_save:
						print_debug("FREEING A MINIGAME NODE! -> ", minigame_node.get_name())
					minigame_node.queue_free()

#Questo qua purtroppo si vede solo se il caricamento è lento, credo...
#Non riesco a inserire un delay artificiale ngl
func _increment_loading_screen_by_value_to_a_cap_of_80_percent(val: int):
	if not loading_bar_enabled:
		return
	var curr_value = UIManager.loading_screen.progress_bar.value
	curr_value += val
	if (curr_value >= 80): #Ho sforato o sono ad 80
		UIManager.loading_screen.set_value(80)
	else:
		UIManager.loading_screen.add_to_value(val)



func reset_save():
	#StateManager.game.remove_child(StateManager.house) #Cancello la casa del save precedente, che contiene tutte le interazioni
	StateManager.house.queue_free()
	var unchanged_house = load("res://game/house/house.tscn").instantiate()
	unchanged_house.set_name("House")
	StateManager.game.add_child(unchanged_house) #Metti la nuova house
	StateManager.house = unchanged_house #Refresha quello che StateManager vede
	
	all_exited_interactions = []
	StateManager.current_minigame = StateManager.starting_current_minigame
	StateManager.player.position =  StateManager.player.starting_position
	StateManager.inventory.slots = []

