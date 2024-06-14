# BaseItem.gd
extends Node2D

"""
TUTORIAL PER UTILIZZO DI OGGETTI ----------
Ogni oggetto è dato dalla scena generic_item.tscn
1) Creare la folder col nome del tuo oggetto nome_obj dentro res://items
2) Creare li dentro tre file:
	"nome_obj.tres" - Per farlo, right click sulla folder > crea nuovo > Risorsa... > seleziona ItemResource > crea
	"nome_obj.gd" - Lo script associato al comportamento dello specifico oggetto. NOTA: la funzione _ready() di quello script viene chiamata dalla scena genrica, usala!
	"nome_obj.png" - La texture dell'oggetto
3) Andare nel file .tres con un text editor esterno, e modificarlo secondo le direttive dentro items/item_resouce.gd

"""
@onready var collision_circle_shape = $ItemInteraction/CollisionShape2D
@onready var sprite2D = $Sprite2D
var item_resource: ItemResource

func _initialize_the_real_item_with_its_properties(item_resource: ItemResource):
	#Cambia il raggio del CollisionShape2D in base al raggio indicato nel file .tres
	collision_circle_shape.shape.radius = item_resource.collision_circle_radius

	#Carica e fai attach dinamico dello script che serve
	var script = load(item_resource.script_path)
	var script_instance = script.new()
	add_child(script_instance)
	
	#Carica l'immagine dell'oggetto
	var image_texture = load(item_resource.sprite_path)
	sprite2D.texture = image_texture


func _ready():
	""" 
	IL NOME DEL NODO NELLA SCENA DEFINISCE L'ITEM CHE VUOI CHE SIA.
	FAI ATTENZIONE CHE LA FOLDER DELL'ITEM SI CHIAMI nome_item E CHE IL .tres ABBIA LA FORMA nome_item.tres
	(Segui il tutorial di generic_item.gd e item_resource.gd
	)
	esempio:
		voglio l'item mazzo_di_chiavi :
			dentro items c'è una folder mazzo_di_chiavi, al cui interno c'è il file mazzo_di_chiavi.tres
			RISPETTA RIGOROSAMENTE QUESTA SINTASSI!
	"""
	var node_name = get_name()
	var tres_path = "res://game/items/" + node_name + "/" + node_name + ".tres"
	
	item_resource = load(tres_path) as ItemResource
	_initialize_the_real_item_with_its_properties(item_resource)
	
func tester():
	print("I am a generic item!")
