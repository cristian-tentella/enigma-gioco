# BaseItem.gd
class_name GenericItem
extends Node2D

"""
TUTORIAL PER UTILIZZO DI OGGETTI ----------
Ogni oggetto è dato dalla scena generic_item.tscn
1) Creare la folder col nome del tuo oggetto nome_obj dentro res://items
2) Creare li dentro almeno il file png di texture:
	"nome_obj.png" - La texture dell'oggetto
"""

@onready var item_interaction = $ItemInteraction
@onready var static_body_2D = $StaticBody2D
@onready var sprite2D = $Sprite2D

@export_category("Item Base Values")
@export_enum("set_of_keys", "polipetto", "spada_laser_rotta", "plutonio", "spada_laser_funzionante", "lista_degli_invitati") var item_name: String
@export var description: String #La descrizione che faremo vedere nell'inventario
#NOTE: La descrizione, cosi come il nome degli item va adattato in funzione della lingua. InventoryManager con un file csv?
@export_group("Extra values")
@export var collision_circle_radius : int = 16 #Negativo se vuoi usare il default
@export var properties: Dictionary  # Proprietà varie, per ora inutilizzato. Potrebbe essere un posto per mettere proprietà custom di un oggetto, non in comune con gli altri

var sprite_path: String  # Path to the sprite for this item

"""
UPDATE QUESTO OGNI VOLTA CHE SI INSERISCE UN ITEM SPECIFICO
"""

func _ready():
	""" 
	L'oggetto è un semplice file png con delle proprietà, nessuno script associato
	FAI ATTENZIONE CHE LA FOLDER DELL'ITEM SI CHIAMI nome_item
	esempio:
		voglio l'item mazzo_di_chiavi :
			dentro items c'è una folder mazzo_di_chiavi, al cui interno c'è il file mazzo_di_chiavi.png
			
			RISPETTA RIGOROSAMENTE QUESTA SINTASSI!
	""" 
	generate_both_collision_circles()
	update_sprite2D_texture()


"""
NOTE TO SELF AND OTHERS

Se crei un nodo dentro all'editor visuale, e vuoi modificargli delle proprietà, a meno che quel nodo non sia un singleton,
NON, e ripeto, NON crearlo visualmente dentro l'editor, devi NECESSARIAMENTE crearlo dinamicamente, altrimenti
per qualche motivo è un nodo solo per ogni istanza della classe in cui si trova.

Avevo messo "CollisionShape2D" dentro alla scena di generic_item.tscn,
e per tutti il radius restava uguale, perché per il primo generic_item1 modificava con un certo raggio,
e poi generic_item2 ricambiava il raggio dello stesso CollisionShape2D, quindi tutti avevano lo stesso identico raggio.
Non so bene come funzioni, ma se avete problemi di questo tipo, create dinamicamente l'albero dei nodi come ho
fatto qui sotto.

"""
func generate_both_collision_circles():
	var new_radius = collision_circle_radius
	
	var item_interaction_collision_circle_shape = CollisionShape2D.new()
	var circle_shape_item = CollisionShapeCreator.create_circle_shape(item_interaction_collision_circle_shape, new_radius)
	item_interaction.add_child(item_interaction_collision_circle_shape)
	
	var actual_collision_circle_shape = CollisionShape2D.new()
	var circle_shape_static = CollisionShapeCreator.create_circle_shape(actual_collision_circle_shape, new_radius)
	static_body_2D.add_child(actual_collision_circle_shape)


func update_sprite2D_texture():
	#Carica l'immagine dell'oggetto
	var sprite_path = "res://game/items/"+item_name+"/"+item_name+".png"
	var image_texture = load(sprite_path)
	sprite2D.texture = image_texture
