class_name KeyLockedContainerBehavior

"""PSEUDOCODE IDEA WHEN INVENTORY WILL BE COMPLETED:
	var set_of_keys_owned = Inventory.get("set_of_keys")
		if set_of_keys_owned == null:
			#Mostra una finestra di dialogo che dice che ti serve un mazzo di chiavi
			return false #Non sono riuscito ad aprirla
		var key_selected = set_of_keys_owned.get_selected_key()
		
		if key_selected == key_number:
			return true
			
		return false
"""

#Non avendo l'inventario, per ora returna true sempre, cioè appena ci clicco la sblocco e basta
#func try_to_unlock(key_number) -> bool:
#	return true
