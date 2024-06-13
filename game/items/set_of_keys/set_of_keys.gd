extends Node

#Il mazzo di chiavi è astratto a una banale lista di numeri, a ogni numero corrisponde il numero della chiave, quindi la chiave in sé
var number_list = [1, 2, 3, 4, 5, 6, 7, 8]
var current_number_selected = 1 #Si usa per i minigiochi. Ci sarà un metodo che controlla se hai fatto la scelta giusta con questo get

func set_current_number_selected(num: int):
	current_number_selected = num
	
func get_current_number_selected():
	return current_number_selected

# Viene chiamata ogni volta che da qualche parte entra in scena un nodo di tipo GenericItem, con nome "mazzo_di_chiavi"
func _ready():
	print("") # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
