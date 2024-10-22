# BaseItem.gd
class_name PickableItem
extends Node2D

"""
(old GenericItem)

TUTORIAL PER UTILIZZO DI OGGETTI ----------
Ogni oggetto è dato dalla scena generic_item.tscn
1) Creare la folder col nome del tuo oggetto nome_obj dentro res://items
2) Creare li dentro almeno il file png di texture:
	"nome_obj.png" - La texture dell'oggetto
"""

@onready var item_interaction = $PickableItemInteraction
@onready var static_body_2D = $StaticBody2D
@onready var sprite2D = $Sprite2D

@export_category("Item Base Values")
@export_enum("set_of_keys", "polipetto", "plutonio_radioattivo", "spada_laser", "lista_degli_invitati") var item_name: String
var description: String #La descrizione che faremo vedere nell'inventario. Viene pescata dal file di traduzioni nel _ready()
@export var is_corporeo: bool = false
@export var dialogue_id: String = "Nessun dialogo" #Dialogo che parte quando lo raccogli
#NOTE: La descrizione, cosi come il nome degli item va adattato in funzione della lingua. InventoryManager con un file csv?
@export_group("Extra Values")
@export var collision_circle_radius : int = 16 #Negativo se vuoi usare il default
@export var properties: Dictionary  # Proprietà varie, per ora inutilizzato. Potrebbe essere un posto per mettere proprietà custom di un oggetto, non in comune con gli altri

#INTERACTION VARIABLES ===================
@export_group("Interaction Values")
@export var minigame_requirement : int = 0 # L'interazione sarà disponibile quando ti trovi su quel minigame O SUPERIORE

@export var destroy_after_minigame_requirement_number: int = -1 #Se provo a interagire con questa interazione una volta superato questo requirement, fa queue_free()
@export var just_proc_once : bool = true #Se voglio che l'interazione ci sia una volta sola in tutto il gioco
@export var increments_current_minigame: bool = false



var sprite_path: String  # Path to the sprite for this item
var collision_shapes: Array[CollisionShape2D]

var localized_item_name: String
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
	
	assert(item_name!=null)
	assign_interaction_variables()
	generate_both_collision_circles()
	update_sprite2D_texture()
	#_associate_description_from_traslation_file()
	self.item_interaction.dialogue_id = self.dialogue_id

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

Il dialogue ID serve per mostrare un certo dialogo quando si raccoglie un oggetto.
Don't mind come è stato implementato, ti basta sapere che se in quella variabile esportata ci scrivi "pippo", ti parte il dialogo "pippo",
e infine ti dice "oggetto aggiunto all'inventario".

"""
func assign_interaction_variables():
	item_interaction.minigame_requirement = self.minigame_requirement
	item_interaction.destroy_after_minigame_requirement_number = self.destroy_after_minigame_requirement_number
	item_interaction.just_proc_once = self.just_proc_once
	item_interaction.increments_current_minigame = self.increments_current_minigame
	

func generate_both_collision_circles():
	var new_radius = collision_circle_radius
	
	var item_interaction_collision_circle_shape = CollisionShape2D.new()
	CollisionShapeCreator.create_circle_shape(item_interaction_collision_circle_shape, new_radius)
	item_interaction.add_child(item_interaction_collision_circle_shape)
	collision_shapes.append(item_interaction_collision_circle_shape)
	
	if is_corporeo:
		var actual_collision_circle_shape = CollisionShape2D.new()
		CollisionShapeCreator.create_circle_shape(actual_collision_circle_shape, new_radius)
		static_body_2D.add_child(actual_collision_circle_shape)
		collision_shapes.append(actual_collision_circle_shape)


func update_sprite2D_texture():
	#Carica l'immagine dell'oggetto
	sprite_path = "res://game/items/"+item_name+"/"+item_name+".png"
	var image_texture = load(sprite_path)
	sprite2D.texture = image_texture

func remove_from_map():
	self.hide()
	self.destroy_collision_shapes_forever()

func destroy_collision_shapes_forever():
	for c in collision_shapes:
		c.queue_free()
	collision_shapes.clear()

func _associate_description_from_traslation_file():
	var item_description_id = item_name+"_description" #Chiamare il dialogo set_of_keys_description
	self.description = DialogueManager._item_description_id_to_item_description(item_description_id)

func _associate_name_from_traslation_file():
	var item_name_id = item_name #Chiamare la entry set_of_keys come item_:name
	self.localized_item_name = DialogueManager._item_description_id_to_item_description(item_name_id)
